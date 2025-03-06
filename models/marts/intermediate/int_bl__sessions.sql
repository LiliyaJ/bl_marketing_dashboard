with source as (
    
    select 
    
        *,
        string_agg(channel, ' → ') over (
            partition by user_id 
            order by user_visits_seq 
            rows between unbounded preceding and current row
        ) AS full_path,
    
        max(user_visits_seq) over (partition by user_id) max_visits,
        sum(costs) over (partition by user_id) costs_per_cj,
        sum(num_contracts) over (partition by user_id) contracts_per_cj,
        count(*) over (partition by user_id) sessions,
        count(distinct user_id) over (partition by user_id) users,
        exp(0.5 * user_visits_seq) AS raw_weight_decay

    from {{ ref(stg_bl__sessions) }}

)

, decay as (
    select
        user_id,
        sum(raw_weight_decay) total_weight_decay
    from t1
    group by user_id

)

, transformed as (

    *,
    case when user_visits_seq = max_visits then true else false end last_touch,
    case when user_visits_seq = 1 and max_visits > 1 then true else false end first_touch,
    case when user_visits_seq = 1 and max_visits = 1 then true else false end single_touch,
    raw_weight_decay / total_weight_decay normalized_weight_decay

    from source join decay on source.user_id = decay.user_id

)

select * from transformed