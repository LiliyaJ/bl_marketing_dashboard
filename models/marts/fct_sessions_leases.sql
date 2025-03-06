with sessions as (
    
    select * from {{ ref('int_bl__sessions') }}   

)

, leases as (

    select * from {{ ref('stg_bl__leases') }}

)

select  
    sessions.*,
    leases.bike_brand,
    leases.bike_type,
    leases.state,
    leases.status,
    leases.saleprice_gross

from sessions left join leases on sessions.leasing_contract_id = leases.leasing_contract_id
order by user_id, user_visits_seq

