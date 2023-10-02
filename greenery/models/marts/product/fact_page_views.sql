{{
  config(
    materialized='table'
  )
}}

with session_timing_agg as (
    select * from {{ ref('int_session_timing') }}
)

{% set event_types = [
  'page_view',
  'add_to_cart',
  'checkout',
  'package_shipped'
] %}

select e.session_id,
        e.user_id,
        coalesce(e.product_id,oi.product_id) as product_id,
        session_started_at,
        session_ended_at,
        {% for i in event_types %}
        --sum(case when e.event_type = '{{ i }}' then 1 else 0 end) as {{ i }}s,
        {{ sum_of('e.event_type',i ) }} as {{ i }}s,
        {% endfor %}
        datediff('minute',session_started_at,session_ended_at) as session_length_minutes
from {{ ref('stg_postgres__events') }} e
left join {{ ref('stg_postgres__order_items') }} oi
    on oi.order_id = e.order_id
left join session_timing_agg st
    on st.session_id = e.session_id
group by 1,2,3,4,5
