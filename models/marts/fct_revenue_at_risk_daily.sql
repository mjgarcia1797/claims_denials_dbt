{{ config(
    materialized='incremental',
    unique_key='as_of_date'
) }}

with base as (
    select
        service_date as as_of_date,
        payer,
        sum(initial_denial_amount) as denied_amount,
        sum(total_overturned_amount) as overturned_amount,
        sum(final_denied_amount) as net_revenue_at_risk
    from {{ ref('fct_denial_resolution') }}
    group by 1, 2
),

daily as (
    select
        as_of_date,
        payer,
        denied_amount,
        overturned_amount,
        net_revenue_at_risk
    from base
)

select * from daily

{% if is_incremental() %}
where as_of_date > (select max(as_of_date) from {{ this }})
{% endif %}