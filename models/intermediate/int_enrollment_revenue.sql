-- One row per enrollment: the training revenue invoiced for it.
-- Aggregated before any join, so that an enrollment with several lines is counted once.
select
    enrollment_id,
    sum(amount_excl_tax) as training_revenue
from {{ ref('stg_invoice_lines') }}
where line_type = 'TRAINING'
group by enrollment_id
