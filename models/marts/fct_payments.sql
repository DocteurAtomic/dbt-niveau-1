-- One row per payment received, with the session and the company of its invoice.
-- Incremental: each run adds the payments received after the last one already in the table.
{{ config(materialized='incremental', unique_key='payment_id') }}

select
    p.payment_id,
    p.invoice_id,
    i.session_id,
    i.company_id,
    p.payment_date,
    p.amount,
    p.payment_method_code
from {{ ref('stg_payments') }} as p
left join {{ ref('stg_invoices') }} as i
    on i.invoice_id = p.invoice_id

{% if is_incremental() %}
where p.payment_date > (select max(payment_date) from {{ this }})
{% endif %}
