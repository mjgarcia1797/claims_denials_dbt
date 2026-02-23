select *
from {{ ref('stg_appeals') }}
where appeal_resolution_date is not null
  and appeal_date is not null
  and appeal_resolution_date < appeal_date
