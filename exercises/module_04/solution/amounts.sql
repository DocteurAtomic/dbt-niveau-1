{#
  Macros on invoiced amounts. A VAT rate is stored as a percentage: 20.00 means 20 %.
#}

{# Converts an amount excluding tax into an amount including tax, rounded to the cent. #}
{% macro to_incl_tax(amount_excl_tax, vat_rate) %}
    cast({{ amount_excl_tax }} * (1 + {{ vat_rate }} / 100) as decimal(18, 2))
{% endmacro %}

{# Converts an amount including tax into an amount excluding tax, rounded to the cent. #}
{% macro to_excl_tax(amount_incl_tax, vat_rate) %}
    cast({{ amount_incl_tax }} / (1 + {{ vat_rate }} / 100) as decimal(18, 2))
{% endmacro %}
