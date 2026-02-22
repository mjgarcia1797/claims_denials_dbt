with denials as (
    select * from {{ ref('stg_denials') }}
),

appeals as (
    select * from {{ ref('stg_appeals') }}
),

appeal_agg as (
    -- one row per denial_id (in case a denial has multiple appeals)
    select
        denial_id,
        max(appeal_resolution_date) as last_appeal_resolution_date,
        -- if any appeal is approved, treat as approved overall
        max(case when lower(appeal_outcome) = 'approved' then 1 else 0 end) as any_approved,
        sum(overturned_amount) as total_overturned_amount
    from appeals
    group by 1
),

final as (
    select
        d.denial_id,
        d.claim_line_id,
        d.denial_code,
        d.denial_reason,
        d.denial_date,
        d.initial_denial_amount,

        a.last_appeal_resolution_date,
        a.any_approved,
        coalesce(a.total_overturned_amount, 0) as total_overturned_amount,

        case
            when a.denial_id is null then 'Denied - No Appeal'
            when a.any_approved = 1 then 'Overturned'
            else 'Denied - Appeal Upheld'
        end as final_outcome,

        -- revenue at risk after appeals
        greatest(d.initial_denial_amount - coalesce(a.total_overturned_amount, 0), 0) as final_denied_amount

    from denials d
    left join appeal_agg a
        on d.denial_id = a.denial_id
)

select * from final