-- An invoice must have at least one line: revenue is computed from the lines.
-- Returns the invoices without any line. Kept as a warning: the fix belongs to the
-- back office, and the project must still build while it is pending.
{{ config(severity='warn') }}

select
    i.invoice_id,
    i.invoice_date,
    i.amount_excl_tax
from {{ ref('stg_invoices') }} as i
left join {{ ref('stg_invoice_lines') }} as l
    on l.invoice_id = i.invoice_id
where l.invoice_id is null
