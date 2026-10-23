-- A payment cannot be received before the invoice it pays was issued.
-- Returns the payments dated before their invoice.
select
    p.payment_id,
    p.invoice_id,
    p.payment_date,
    i.invoice_date
from {{ ref('fct_payments') }} as p
inner join {{ ref('stg_invoices') }} as i
    on i.invoice_id = p.invoice_id
where p.payment_date < i.invoice_date
