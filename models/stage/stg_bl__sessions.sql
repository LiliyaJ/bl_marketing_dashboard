with 
    source as (

        select
        
            session_date,
            user_id,
            channel,
            device,
            leasing_contract_id,
            sum(costs) costs,
            count(distinct session_id) num_of_sessions,
            countif(leasing_contract_id is not null) contracts
        
        from {{ source('bl_marketing_dashboard', 'sessions') }}
        group by  session_date, user_id, channel, device, leasing_contract_id
    )

select * from source
