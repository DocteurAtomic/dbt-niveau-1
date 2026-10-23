-- Number of sessions and first session date of every course in the catalog.
select
    c.course_id,
    c.title,
    c.domain_code,
    count(s.session_id) as session_count,
    min(s.start_date) as first_session
from {{ source('raw', 'courses') }} as c
left join {{ source('raw', 'course_sessions') }} as s
    on s.course_id = c.course_id
group by all
order by session_count desc
