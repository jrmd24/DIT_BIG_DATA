WITH Books AS 
(
    select * 
    from {{ ref("stg_books") }} 
), Ventes AS 
(
    select annees, 
          books_id,
    from {{ ref("fact_ventes") }} 
)

SELECT Books.id as id, 
        Books.category_id as category_id, 
        Books.code as code, 
        Books.intitule as intitule, 
        Books.isbn_10 as isbn_10, 
        Books.isbn_13 as isbn_13, 
        Books.created_at as created_at, 
        Ventes.annees as annees
FROM Books 
INNER JOIN Ventes ON Ventes.books_id = Books.id
