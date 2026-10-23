-- One row per course of the catalog: completed sessions, attendees, evaluations,
-- response rate and average rating.
-- Evaluations are counted per session before the join to the sessions, and the average
-- is computed from the sum of the ratings, so that each evaluation weighs the same.
with session_evaluations as (
    select
        e.session_id,
        count(*) as evaluation_count,
        sum(v.rating) as rating_sum
    from {{ ref('stg_evaluations') }} as v
    inner join {{ ref('stg_enrollments') }} as e
        on e.enrollment_id = v.enrollment_id
    group by e.session_id
),

courses as (
    select
        s.course_id,
        count(*) as completed_session_count,
        sum(s.attendee_count) as attendee_count,
        sum(v.evaluation_count) as evaluation_count,
        sum(v.rating_sum) as rating_sum
    from {{ ref('fct_sessions') }} as s
    left join session_evaluations as v
        on v.session_id = s.session_id
    where s.status = 'COMPLETED'
    group by s.course_id
)

select
    c.course_id,
    c.title as course_title,
    c.domain_name,
    coalesce(s.completed_session_count, 0) as completed_session_count,
    coalesce(s.attendee_count, 0) as attendee_count,
    coalesce(s.evaluation_count, 0) as evaluation_count,
    round(s.evaluation_count / nullif(s.attendee_count, 0), 2) as response_rate,
    round(s.rating_sum / s.evaluation_count, 2) as avg_rating
from {{ ref('dim_courses') }} as c
left join courses as s
    on s.course_id = c.course_id
