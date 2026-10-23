select
    c.course_id,
    c.course_code,
    c.title,
    cat.category_name,
    dom.domain_name,
    c.duration_days,
    c.max_attendees
from {{ ref('stg_courses') }} as c
left join {{ ref('course_categories') }} as cat
    on cat.category_code = c.category_code
left join {{ ref('course_domains') }} as dom
    on dom.domain_code = c.domain_code
