with source as (

    select * from {{ source('raw', 'denials') }}

),

clean as (

    select
        cast(denial_id as varchar) as denial_id,
        cast(claim_line_id as varchar) as claim_line_id,
        cast(denial_code as varchar) as denial_code,
        cast(denial_reason as varchar) as denial_reason,
        cast(denial_date as date) as denial_date,
        cast(initial_denial_amount as double) as initial_denial_amount

    from source

)

select * from clean