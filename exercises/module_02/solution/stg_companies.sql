select
    company_id,
    company_name,
    country_code,
    industry,
    created_at,
    email_domain
from {{ source('raw', 'companies') }}
