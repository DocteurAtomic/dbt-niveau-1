-- One row per year of payment: the amount received excluding tax, one column per payment method.
{% set methods = dbt_utils.get_column_values(ref('stg_payments'), 'payment_method_code', order_by='payment_method_code') %}

with payments as (
    select
        year(p.payment_date) as payment_year,
        p.payment_method_code,
        {{ to_excl_tax('p.amount', 'i.vat_rate') }} as amount_excl_tax
    from {{ ref('fct_payments') }} as p
    inner join {{ ref('stg_invoices') }} as i
        on i.invoice_id = p.invoice_id
)

select
    payment_year,
    {%- for method in methods %}
    sum(amount_excl_tax) filter (where payment_method_code = '{{ method }}') as {{ method | lower }}_amount_excl_tax,
    {%- endfor %}
    sum(amount_excl_tax) as total_amount_excl_tax
from payments
group by payment_year
