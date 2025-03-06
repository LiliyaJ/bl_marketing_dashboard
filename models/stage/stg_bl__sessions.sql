with 
    source as (

        select * from {{ source('bl_marketing_dashboard', 'sessions') }}

    ),

    transformed as (
        select
        
            session_date,
            user_id,
            channel,
            channel_type,
            costs,
            device,
            leasing_contract_id,

            -- user visits sequence
            row_number() over(
            partition by user_id
            order by session_date, user_id
            ) user_visits_seq,

            case when leasing_contract_id is not null then 1 else 0 end contracts 
        
        from source
    )

select * from transformed
