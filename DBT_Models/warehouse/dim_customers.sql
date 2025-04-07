select id, 
        code, 
        first_name, 
        last_name,
        CONCAT(first_name, ' ', last_name) as nom,
        created_at 
from {{ ref("stg_customers") }} 