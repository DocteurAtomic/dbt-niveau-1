select
    payment_id,
    invoice_id,
    payment_date,
    amount,
    payment_method_code
from {{ source('raw', 'payments') }}
