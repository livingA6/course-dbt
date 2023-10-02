select pv.product_id,
        pr.name as product_name,
        count(distinct case when checkouts > 0 then session_id end) / count(distinct session_id) * 100 as conv_rate_pct
from dev_db.dbt_tomiasikainenkaitofi.fact_page_views pv
left join dev_db.dbt_tomiasikainenkaitofi.stg_postgres__products pr on pv.product_id = pr.product_id
group by 1,2