CREATE TABLE RAW.category (
  id INTEGER PRIMARY KEY,
  intitule VARCHAR(255),
  created_at TIMESTAMP
);

CREATE TABLE RAW.books (
  id INTEGER PRIMARY KEY,
  category_id INTEGER,
  code VARCHAR(255),
  intitule VARCHAR(255),
  isbn_10 VARCHAR(255),
  isbn_13 VARCHAR(255),
  created_at TIMESTAMP
);

CREATE TABLE RAW.customers (
  id INTEGER PRIMARY KEY,
  code VARCHAR(255),
  first_name VARCHAR(255),
  last_name VARCHAR(255),
  created_at TIMESTAMP
);

CREATE TABLE RAW.factures (
  id INTEGER PRIMARY KEY,
  code VARCHAR(255),
  date_edit VARCHAR(255),
  customers_id INTEGER,
  qte_totale INTEGER,
  total_amount FLOAT,
  total_paid FLOAT,
  created_at TIMESTAMP
);

CREATE TABLE RAW.ventes (
  id INTEGER PRIMARY KEY,
  code VARCHAR(255),
  date_edit VARCHAR(255),
  factures_id INTEGER,
  books_id INTEGER,
  pu FLOAT,
  qte INTEGER,
  created_at TIMESTAMP
);

ALTER TABLE RAW.books ADD CONSTRAINT fk_books_category
FOREIGN KEY (category_id) REFERENCES RAW.category (id);

ALTER TABLE RAW.ventes ADD CONSTRAINT fk_ventes_books
FOREIGN KEY (books_id) REFERENCES RAW.books (id);

ALTER TABLE RAW.ventes ADD CONSTRAINT fk_ventes_factures
FOREIGN KEY (factures_id) REFERENCES RAW.factures (id);

ALTER TABLE RAW.factures ADD CONSTRAINT fk_factures_customers
FOREIGN KEY (customers_id) REFERENCES RAW.customers (id);