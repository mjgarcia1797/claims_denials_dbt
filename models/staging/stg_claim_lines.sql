with source as (

    select * from {{ source('raw', 'claim_lines') }}

),

clean as (

    select
        cast(claim_line_id as varchar) as claim_line_id,
        cast(claim_id as varchar) as claim_id,
        cast(member_id as varchar) as member_id,
        cast(payer as varchar) as payer,
        cast(provider_id as varchar) as provider_id,
        cast(service_date as date) as service_date,
        cast(cpt_code as varchar) as cpt_code,
        cast(billed_amount as double) as billed_amount,
        cast(allowed_amount as double) as allowed_amount,
        cast(paid_amount as double) as paid_amount

    from source

)

select * from clean