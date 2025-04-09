import os
from datetime import datetime, timedelta

import mysql.connector
import pandas as pd
import snowflake.connector
from airflow import DAG

# from airflow.operators.bash import BashOperator
from airflow.operators.python import PythonOperator

# from airflow.providers.snowflake.operators.snowflake import SnowflakeOperator
from airflow.providers.ssh.operators.ssh import SSHOperator
from snowflake.connector.pandas_tools import write_pandas


def delete_file(file_path):
    try:
        os.remove(file_path)
        print(f"File '{file_path}' has been successfully deleted.")
    except FileNotFoundError:
        print(f"Error: File '{file_path}' not found.")
    except PermissionError:
        print(f"Error: Permission denied to delete file '{file_path}'.")
    except OSError as e:
        print(f"Error deleting file '{file_path}': {e}")


default_args = {
    "owner": "airflow",
    "start_date": datetime(2023, 1, 1),
    "retries": 1,
    "retry_delay": timedelta(minutes=1),
}

sf_conn = snowflake.connector.connect(
    user="jrmd",
    password="7px5nQwX5rPhqCz",
    account="pb62266.europe-west2.gcp",
    warehouse="COMPUTE_WH",
    database="BOOKSHOP",
    schema="RAW",
)

mysql_conn = mysql.connector.connect(
    user="book-user",
    password="book",
    host="book-mysql",
    database="bookshop",
)

dag = DAG(
    "mysql_to_snowflake_dbt_pipeline",
    default_args=default_args,
    description="Ingest from MySQL to Snowflake and run dbt",
    schedule_interval="@daily",
    catchup=False,
)

ingested_ts_csv_file_path = "/tmp/last_ingested_ts_per_table.csv"

list_of_tables = ["category", "books", "customers", "factures", "ventes"]
# list_of_last_ingested_timestamps = []


def extract_snowflake_last_ingested_timestamps(**kwargs):
    list_of_last_ingested_timestamps = []
    for table in list_of_tables:
        cursor = sf_conn.cursor()
        sql = f"SELECT MAX(created_at) FROM {table};"
        cursor.execute(sql)
        result = cursor.fetchone()
        if result and result[0]:
            list_of_last_ingested_timestamps.append(result[0])
        else:
            list_of_last_ingested_timestamps.append(None)

    data = {
        "table_name": list_of_tables,
        "last_ingested_ts": list_of_last_ingested_timestamps,
    }
    df = pd.DataFrame(data)
    df.to_csv(ingested_ts_csv_file_path, index=False)


def extract_mysql_data(**kwargs):
    ts_df = pd.read_csv(ingested_ts_csv_file_path, parse_dates=["last_ingested_ts"])
    for table in list_of_tables:
        max_ingested_ts_series = ts_df[ts_df["table_name"] == table]["last_ingested_ts"]
        max_ingested_ts = None
        if not max_ingested_ts_series.empty:
            max_ingested_ts = max_ingested_ts_series.iloc[0]

        sql = f"SELECT * FROM {table}"
        if max_ingested_ts:
            sql += f" WHERE created_at > '{max_ingested_ts}'"
        df = pd.read_sql(sql, mysql_conn)
        df.to_csv(f"/tmp/{table}_table.csv", index=False)


def load_to_snowflake(**kwargs):

    try:
        for table in list_of_tables:
            file_path = f"/tmp/{table}_table.csv"
            if os.path.exists(file_path):
                print(f"File exists: {file_path}. Proceeding to read.")
                df = pd.read_csv(file_path)
                success, nchunks, nrows, _ = write_pandas(
                    sf_conn, df, table, quote_identifiers=False
                )
                print(f"Success for table {table}: {success}, Rows: {nrows}")
                delete_file(file_path)
            else:
                print(f"File not found: {file_path}. Skipping load for this table.")
    finally:
        sf_conn.close()
        delete_file(ingested_ts_csv_file_path)


extract_TS_task = PythonOperator(
    task_id="extract_snowflake_max_ts",
    python_callable=extract_snowflake_last_ingested_timestamps,
    dag=dag,
)
extract_task = PythonOperator(
    task_id="extract_mysql", python_callable=extract_mysql_data, dag=dag
)

load_task = PythonOperator(
    task_id="load_to_snowflake", python_callable=load_to_snowflake, dag=dag
)


dbt_run_command = SSHOperator(
    task_id="run_dbt_transformations",
    ssh_conn_id="dbt_ssh_connection",  # The connection ID you defined in Airflow
    command="cd /usr/app/bookshop && dbt run",  # The command to execute on the remote server
    dag=dag,
    do_xcom_push=True,  # Optionally push the command output to XCom
)


extract_TS_task >> extract_task >> load_task >> dbt_run_command
