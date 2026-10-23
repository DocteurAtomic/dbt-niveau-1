-- One row per enrollment: the training revenue invoiced for it, excluding and including tax.
-- Aggregated before any join, so that an enrollment with several lines is counted once.
select
    l.enrollment_id,
    sum(l.amount_excl_tax) as training_revenue,
    sum({{ to_incl_tax('l.amount_excl_tax', 'i.vat_rate') }}) as training_revenue_incl_tax
from {{ ref('stg_invoice_lines') }} as l
inner join {{ ref('stg_invoices') }} as i
    on i.invoice_id = l.invoice_id
where l.line_type = 'TRAINING'
group by l.enrollment_id
