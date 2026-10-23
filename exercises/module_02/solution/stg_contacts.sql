select
    contact_id,
    title,
    first_name,
    last_name,
    email,
    company_id,
    birth_date
from {{ source('raw', 'contacts') }}
