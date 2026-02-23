with final_outcomes as (
    select * from {{ ref('int_denial_final_outcome') }}
),

claim_context as (
    select
        claim_line_id,
        claim_id,
        member_id,
        payer,
        provider_id,
        service_date,
        cpt_code,
        billed_amount,
        allowed_amount,
        paid_amount
    from {{ ref('stg_claim_lines') }}
),

joined as (
    select
        f.denial_id,
        f.claim_line_id,
        c.claim_id,
        c.member_id,
        c.payer,
        c.provider_id,
        c.service_date,
        c.cpt_code,

        c.billed_amount,
        c.allowed_amount,
        c.paid_amount,

        f.initial_denial_amount,
        f.total_overturned_amount,
        f.final_denied_amount,
        f.final_outcome,
        f.last_appeal_resolution_date

    from final_outcomes f
    left join claim_context c
        on f.claim_line_id = c.claim_line_id
)

select * from joined