with users as (
    select * from {{ref('stg_postgres__users')}}
)
, products_in_orders as(
    select * from {{ref('int_products_in_orders')}}
)
, user_orders as (
    select * from {{ref('int_user_orders')}}
)
, products_purchased as (
    select o.user_id,
            count(oi.product_id) as products_purchased
    from {{ref('stg_postgres__order_items')}} oi
    left join {{ref('stg_postgres__orders')}} o
        on o.order_id = oi.order_id
    group by 1
)

select u.user_id,
        o.orders is not null as is_buyer,
        coalesce(o.orders,0) >= 2 as frequent_buyer,
        o.first_order_created_at,
        o.last_order_created_at,
        o.orders,
        coalesce(total_spend,0) as total_spend,
        coalesce(products_purchased,0) as products_purchased
from users u
left join user_orders o
    on o.user_id = u.user_id
left join products_purchased p
    on p.user_id = u.user_id
