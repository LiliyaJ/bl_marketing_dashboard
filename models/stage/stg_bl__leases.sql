with 
    source as (

        select * 
        
        from {{ source('bl_marketing_dashboard', 'leases') }}

    )

select * from source
