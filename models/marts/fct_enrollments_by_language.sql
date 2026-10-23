-- One row per year of session start: the enrollments in each language of the sessions.
-- The languages are read from the data at compile time, one column per language.
{% set languages = dbt_utils.get_column_values(ref('stg_course_sessions'), 'language_code', order_by='language_code') %}

select
    year(s.start_date) as start_year,
    {%- for language in languages %}
    count(*) filter (where s.language_code = '{{ language }}') as {{ language | lower }}_enrollments,
    {%- endfor %}
    count(*) as total_enrollments
from {{ ref('stg_enrollments') }} as e
inner join {{ ref('stg_course_sessions') }} as s
    on s.session_id = e.session_id
group by year(s.start_date)
