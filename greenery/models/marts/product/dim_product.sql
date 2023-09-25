select prod.product_id,
        prod.name as product_name,
        prod.price as product_price,
        inventory
from {{ref('stg_postgres__products')}} prod