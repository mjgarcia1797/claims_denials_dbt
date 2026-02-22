select *
from {{ ref('int_denial_final_outcome') }}
where final_outcome = 'Overturned'
  and final_denied_amount <> 0