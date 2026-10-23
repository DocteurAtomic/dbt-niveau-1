select
    invoice_id,
    line_number,
    line_type,
    enrollment_id,
    quantity,
    unit_price,
    amount_excl_tax
from {{ source('raw', 'invoice_lines') }}
