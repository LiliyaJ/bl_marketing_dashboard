with sessions as (
    
    select * from {{ ref('int_bl__sessions') }}   

)

, leases as (

    select * from {{ ref('stg_bl__leases') }}

)

select  
    sessions.*,
    case when user_visits_seq = max_visits then sessions_per_cj else 0 end sessions,
    case when user_visits_seq = max_visits then users_per_cj else 0 end users,
    leases.bike_brand,
    leases.bike_type,
    leases.state,
    leases.status,
    leases.saleprice_gross

from sessions left join leases on sessions.leasing_contract_id = leases.leasing_contract_id
order by user_id, user_visits_seq

