select id ,
          code ,
          date_edit,
          YEAR(date_edit) AS annees,          
          CASE EXTRACT(MONTH, date_edit)
                WHEN 1 THEN 'Janvier'
                WHEN 2 THEN 'Février'
                WHEN 3 THEN 'Mars'
                WHEN 4 THEN 'Avril'
                WHEN 5 THEN 'Mai'
                WHEN 6 THEN 'Juin'
                WHEN 7 THEN 'Juillet'
                WHEN 8 THEN 'Août'
                WHEN 9 THEN 'Septembre'
                WHEN 10 THEN 'Octobre'
                WHEN 11 THEN 'Novembre'
                WHEN 12 THEN 'Décembre'
                ELSE NULL -- Handle potential unexpected values
            END AS mois,
          CASE DAYNAME(date_edit)
            WHEN 'Mon' THEN 'Lundi'
            WHEN 'Tue' THEN 'Mardi'
            WHEN 'Wed' THEN 'Mercredi'
            WHEN 'Thu' THEN 'Jeudi'
            WHEN 'Fri' THEN 'Vendredi'
            WHEN 'Sat' THEN 'Samedi'
            WHEN 'Sun' THEN 'Dimanche'
            ELSE NULL -- Handle potential unexpected values
            END AS jour,
          factures_id,
          books_id,
          pu,
          qte,
          created_at
from {{ ref("stg_ventes") }} 