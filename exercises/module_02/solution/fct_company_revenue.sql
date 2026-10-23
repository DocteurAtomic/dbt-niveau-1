-- One row per client company: trainees sent, enrollments and invoiced training revenue.
select
    co.company_id,
    co.company_name,
    co.country_code,
    count(distinct e.contact_id) as trainee_count,
    count(*) as enrollment_count,
    coalesce(sum(r.training_revenue), 0) as training_revenue
from {{ ref('stg_enrollments') }} as e
inner join {{ ref('stg_contacts') }} as c
    on c.contact_id = e.contact_id
inner join {{ ref('stg_companies') }} as co
    on co.company_id = c.company_id
left join {{ ref('int_enrollment_revenue') }} as r
    on r.enrollment_id = e.enrollment_id
group by all
