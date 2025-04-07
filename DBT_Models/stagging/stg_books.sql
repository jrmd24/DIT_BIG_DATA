SELECT *
FROM {{ source('raw', 'books') }}