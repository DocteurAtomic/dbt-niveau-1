-- One row per session: enrollments, attendance, fill rate and invoiced training revenue.
with enrollments as (
    select
        e.session_id,
        count(*) as enrollment_count,
        count(*) filter (where e.is_cancelled) as cancellation_count,
        count(*) filter (where e.attended) as attendee_count,
        sum(r.training_revenue) as training_revenue
    from {{ ref('stg_enrollments') }} as e
    left join {{ ref('int_enrollment_revenue') }} as r
        on r.enrollment_id = e.enrollment_id
    group by e.session_id
)

select
    s.session_id,
    s.course_id,
    c.title as course_title,
    c.domain_name,
    s.start_date,
    s.end_date,
    s.status,
    s.language_code,
    s.is_in_house,
    c.max_attendees,
    coalesce(e.enrollment_count, 0) as enrollment_count,
    coalesce(e.cancellation_count, 0) as cancellation_count,
    coalesce(e.attendee_count, 0) as attendee_count,
    round(coalesce(e.enrollment_count - e.cancellation_count, 0) / c.max_attendees, 2) as fill_rate,
    coalesce(e.training_revenue, 0) as training_revenue
from {{ ref('stg_course_sessions') }} as s
inner join {{ ref('dim_courses') }} as c
    on c.course_id = s.course_id
left join enrollments as e
    on e.session_id = s.session_id
