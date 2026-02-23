{% snapshot snap_denial_final_outcome %}

{{
    config(
      target_schema='snapshots',
      unique_key='denial_id',
      strategy='timestamp',
      updated_at='last_appeal_resolution_date'
    )
}}

select
  denial_id,
  claim_line_id,
  final_outcome,
  final_denied_amount,
  last_appeal_resolution_date
from {{ ref('int_denial_final_outcome') }}

{% endsnapshot %}