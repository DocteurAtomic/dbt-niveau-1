-- Three enrollments are extracted twice, as identical rows (data/README.md).
-- distinct removes them; if two rows ever differ, the unique test still fails.
select distinct
    enrollment_id,
    session_id,
    contact_id,
    created_at,
    cancelled_at,
    cancelled_at is not null as is_cancelled,
    discount_pct,
    attended = 1 as attended,
    updated_at
from {{ source('raw', 'enrollments') }}
