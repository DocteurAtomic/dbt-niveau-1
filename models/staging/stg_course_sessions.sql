select
    session_id,
    course_id,
    language_code,
    start_date,
    cast(duration_days as integer) as duration_days,
    start_date + cast(duration_days - 1 as integer) as end_date,
    price as list_price,
    status,
    is_in_house = 1 as is_in_house,
    client_company_id,
    created_at,
    updated_at
from {{ source('raw', 'course_sessions') }}
