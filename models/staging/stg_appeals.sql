with source as (

    select * from {{ source('raw', 'appeals') }}

),

clean as (

    select
        cast(appeal_id as varchar) as appeal_id,
        cast(denial_id as varchar) as denial_id,
        cast(appeal_date as date) as appeal_date,
        cast(appeal_outcome as varchar) as appeal_outcome,
        cast(appeal_resolution_date as date) as appeal_resolution_date,
        cast(overturned_amount as double) as overturned_amount

    from source

)

select * from clean