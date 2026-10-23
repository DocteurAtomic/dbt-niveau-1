select
    invoice_id,
    document_type,
    invoice_date,
    due_date,
    company_id,
    contact_id,
    session_id,
    amount_excl_tax,
    vat_rate,
    amount_incl_tax
from {{ source('raw', 'invoices') }}
