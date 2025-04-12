WITH Ventes AS 
(
    select id, annees, mois, jour, pu, qte, factures_id, books_id 
    from {{ ref("fact_ventes") }} 
), Factures AS 
(
    select id, code, qte_totale, total_amount, total_paid, customers_id
    from {{ ref("fact_factures") }} 
), Category AS 
(
    select id, intitule
    from {{ ref("dim_category") }} 
), Books AS 
(
    select id, code, intitule, isbn_10, isbn_13,category_id
    from {{ ref("dim_books") }} 
), Customers AS 
(
    select id, code, nom
    from {{ ref("dim_customers") }} 
)


SELECT
    
        -- Columns from ventes
    v.id AS id,
    v.annees AS annees,
    v.mois AS mois,
    v.jour AS jour,
    v.pu AS pu,
    v.qte AS qte,

    -- Columns from factures
    f.id AS facture_id,
    f.code AS facture_code,
    f.qte_totale AS facture_total_quantity,
    f.total_amount AS facture_total_amount,
    f.total_paid AS facture_total_paid,
    
    -- Columns from category
    c.intitule AS category_name,

    -- Columns from books
    b.code AS book_code,
    b.intitule AS intitule,
    b.isbn_10 AS isbn_10,
    b.isbn_13 AS isbn_13,

    -- Columns from customers
    cust.code AS customer_code,
    cust.nom AS nom,

    

FROM
    Ventes v
LEFT JOIN
    Factures f ON v.factures_id = f.id
LEFT JOIN
    Books b ON v.books_id = b.id
LEFT JOIN
    Category c ON b.category_id = c.id
LEFT JOIN
    Customers cust ON f.customers_id = cust.id