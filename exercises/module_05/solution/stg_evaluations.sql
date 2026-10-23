-- One row per end-of-course evaluation. One evaluation at most per enrollment.
-- channel is left out: every evaluation of the extract has the value WEB.
select
    evaluation_id,
    enrollment_id,
    evaluated_at,
    rating
from {{ source('raw', 'evaluations') }}
