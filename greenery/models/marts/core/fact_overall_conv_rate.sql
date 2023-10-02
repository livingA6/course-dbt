select count(distinct case when checkouts > 0 then session_id end) / count(distinct session_id) * 100 as conv_rate_pct
from dev_db.dbt_tomiasikainenkaitofi.fact_page_views