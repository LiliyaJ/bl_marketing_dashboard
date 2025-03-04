with 
    source as (

        select * from {{ source('bl_marketing_dashboard', 'sessions') }}

    )

select * from source
