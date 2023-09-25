select  order_id,
        user_id,
        created_at,
        order_total
from {{ref('stg_postgres__orders')}}