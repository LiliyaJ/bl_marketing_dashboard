with 
    source as (

        select * from {{ source('bl_marketing_dashboard', 'sessions') }}

    ),

    transformed as (
        select
        
            session_date,
            user_id,
            channel,
            device,
            leasing_contract_id,

            -- user visits sequence
            row_number() over(
            partition by user_id
            order by session_date, user_id
            ) user_visits_seq

            -- count costs per user, oper date, per channel, per device, per contract
           -- sum(costs) costs,

            -- count number of sessions per user, oper date, per channel, per device, per contract
           -- count(distinct session_id) num_of_sessions,

            -- count contracts
           -- countif(leasing_contract_id is not null) contracts
        
        from source
       -- group by session_date, user_id, 
       --         channel, device, leasing_contract_id
    )

select * from transformed
