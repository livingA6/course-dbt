    select order_id,
            product_id,
    count(product_id) as products_in_order
    from {{ref('stg_postgres__order_items')}}
    group by 1,2