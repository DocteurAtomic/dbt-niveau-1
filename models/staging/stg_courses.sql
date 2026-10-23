select
    course_id,
    course_code,
    title,
    category_code,
    domain_code,
    duration_days,
    max_attendees,
    created_at
from {{ source('raw', 'courses') }}
