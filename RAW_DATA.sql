-- Insert statements for RAW.category (3 categories)
INSERT INTO RAW.category (id, intitule, created_at) VALUES
(1, 'Fiction', CURRENT_TIMESTAMP()),
(2, 'Science', CURRENT_TIMESTAMP()),
(3, 'History', CURRENT_TIMESTAMP());

-- Insert statements for RAW.customers (5 customers)
INSERT INTO RAW.customers (id, code, first_name, last_name, created_at) VALUES
(1, 'CUST001', 'Fatou', 'Diop', CURRENT_TIMESTAMP()),
(2, 'CUST002', 'Mamadou', 'Ndiaye', CURRENT_TIMESTAMP()),
(3, 'CUST003', 'Aminata', 'Seck', CURRENT_TIMESTAMP()),
(4, 'CUST004', 'Ibrahima', 'Fall', CURRENT_TIMESTAMP()),
(5, 'CUST005', 'Awa', 'Mbaye', CURRENT_TIMESTAMP());

-- Insert statements for RAW.books (10 books across categories)
INSERT INTO RAW.books (id, category_id, code, intitule, isbn_10, isbn_13, created_at) VALUES
(201, 1, 'FIC001', 'The Secret Garden', '1234567890', '9781234567897', CURRENT_TIMESTAMP()),
(202, 1, 'FIC002', 'To Kill a Mockingbird', '0987654321', '9780987654328', CURRENT_TIMESTAMP()),
(203, 2, 'SCI001', 'Cosmos', '1122334455', '9781122334452', CURRENT_TIMESTAMP()),
(204, 2, 'SCI002', 'A Brief History of Time', '5544332211', '9785544332218', CURRENT_TIMESTAMP()),
(205, 1, 'FIC003', 'Pride and Prejudice', '1357924680', '9781357924686', CURRENT_TIMESTAMP()),
(206, 3, 'HIS001', 'Sapiens', '0864297531', '9780864297535', CURRENT_TIMESTAMP()),
(207, 3, 'HIS002', 'Guns, Germs, and Steel', '1470369258', '9781470369259', CURRENT_TIMESTAMP()),
(208, 1, 'FIC004', '1984', '9638527410', '9789638527413', CURRENT_TIMESTAMP()),
(209, 2, 'SCI003', 'The Elegant Universe', '0321012345', '9780321012349', CURRENT_TIMESTAMP()),
(210, 3, 'HIS003', 'The Diary of a Young Girl', '0590098765', '9780590098769', CURRENT_TIMESTAMP());

-- Insert statements for RAW.factures (5 invoices, one for each customer)
INSERT INTO RAW.factures (id, code, date_edit, customers_id, qte_totale, total_amount, total_paid, created_at) VALUES
(101, 'INV001', '20250406', 1, 5, 75.50, 75.50, CURRENT_TIMESTAMP()),
(102, 'INV002', '20250406', 2, 3, 35.25, 35.25, CURRENT_TIMESTAMP()),
(103, 'INV003', '20250406', 3, 2, 34.00, 34.00, CURRENT_TIMESTAMP()),
(104, 'INV004', '20250406', 4, 4, 62.75, 62.75, CURRENT_TIMESTAMP()),
(105, 'INV005', '20250406', 5, 3, 48.99, 48.99, CURRENT_TIMESTAMP());

-- Insert statements for RAW.ventes (10 sales, referencing the created factures and books)
INSERT INTO RAW.ventes (id, code, date_edit, factures_id, books_id, pu, qte, created_at) VALUES
(1, 'SALE001', '20250406', 101, 201, 15.99, 2, CURRENT_TIMESTAMP()),
(2, 'SALE002', '20250406', 102, 205, 9.50, 1, CURRENT_TIMESTAMP()),
(3, 'SALE003', '20250406', 101, 203, 22.75, 1, CURRENT_TIMESTAMP()),
(4, 'SALE004', '20250403', 103, 202, 12.00, 2, CURRENT_TIMESTAMP()),
(5, 'SALE005', '20250405', 104, 207, 18.50, 1, CURRENT_TIMESTAMP()),
(6, 'SALE006', '20250406', 102, 209, 7.99, 2, CURRENT_TIMESTAMP()),
(7, 'SALE007', '20250404', 105, 204, 14.25, 1, CURRENT_TIMESTAMP()),
(8, 'SALE008', '20250406', 103, 206, 11.50, 1, CURRENT_TIMESTAMP()),
(9, 'SALE009', '20250405', 104, 208, 25.00, 1, CURRENT_TIMESTAMP()),
(10, 'SALE010', '20250406', 105, 210, 8.75, 2, CURRENT_TIMESTAMP());

