CREATE DATABASE IF NOT EXISTS bookshop;

USE bookshop;

DROP TABLE IF EXISTS ventes;
DROP TABLE IF EXISTS factures;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS books;
DROP TABLE IF EXISTS category;

CREATE TABLE category (
  id integer PRIMARY KEY,
  intitule varchar(255),
  created_at timestamp
);

CREATE TABLE books (
  id integer PRIMARY KEY,
  category_id integer,
  code varchar(255),
  intitule varchar(255),
  isbn_10 varchar(255),
  isbn_13 varchar(255),
  created_at timestamp,
  FOREIGN KEY (category_id) REFERENCES category (id)
);

CREATE TABLE customers (
  id integer PRIMARY KEY,
  code varchar(255),
  first_name varchar(255),
  last_name varchar(255),
  created_at timestamp
);

CREATE TABLE factures (
  id integer PRIMARY KEY,
  code varchar(255),
  date_edit varchar(255),
  customers_id integer,
  qte_totale integer,
  total_amount float,
  total_paid float,
  created_at timestamp,
  FOREIGN KEY (customers_id) REFERENCES customers (id)
);

CREATE TABLE ventes (
  id integer PRIMARY KEY,
  code varchar(255),
  date_edit varchar(255),
  factures_id integer,
  books_id integer,
  pu float,
  qte integer,
  created_at timestamp,
  FOREIGN KEY (books_id) REFERENCES books (id),
  FOREIGN KEY (factures_id) REFERENCES factures (id)
);