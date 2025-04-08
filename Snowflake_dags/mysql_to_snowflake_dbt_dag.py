import os
from datetime import datetime, timedelta

import mysql.connector
import pandas as pd
import snowflake.connector
from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.operators.python import PythonOperator
from snowflake.connector.pandas_tools import write_pandas

default_args = {
    "owner": "airflow",
    "start_date": datetime(2023, 1, 1),
    "retries": 1,
    "retry_delay": timedelta(minutes=2),
}

dag = DAG(
    "mysql_to_snowflake_dbt_pipeline",
    default_args=default_args,
    description="Ingest from MySQL to Snowflake and run dbt",
    schedule_interval="@daily",
    catchup=False,
)

list_of_tables = ["category", "books", "customers", "factures", "ventes"]


def extract_mysql_data(**kwargs):
    conn = mysql.connector.connect(
        user="book-user",
        password="book",
        host="book-mysql",
        database="bookshop",
    )
    for table in list_of_tables:
        df = pd.read_sql(f"SELECT * FROM {table}", conn)
        df.to_csv(f"/tmp/{table}_table.csv", index=False)


def load_to_snowflake(**kwargs):

    conn = snowflake.connector.connect(
        user="jrmd",
        password="7px5nQwX5rPhqCz",
        account="pb62266.europe-west2.gcp",
        warehouse="COMPUTE_WH",
        database="BOOKSHOP",
        schema="RAW",
    )
    for table in list_of_tables:
        df = pd.read_csv(f"/tmp/{table}_table.csv")
        success, nchunks, nrows, _ = write_pandas(
            conn, df, f"BOOKSHOP.RAW.{table.upper()}"
        )
        print(f"Success: {success}, Rows: {nrows}")


extract_task = PythonOperator(
    task_id="extract_mysql", python_callable=extract_mysql_data, dag=dag
)

load_task = PythonOperator(
    task_id="load_to_snowflake", python_callable=load_to_snowflake, dag=dag
)

dbt_container_name = "dbt"

dbt_run = BashOperator(
    task_id="run_dbt_transformations",
    bash_command=f"docker exec -it {dbt_container_name} bash -c 'cd /usr/app/bookshop && dbt run'",
    dag=dag,
)
