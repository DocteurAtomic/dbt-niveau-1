{#
  Loads one delivery of the source system into the raw schema.
  Each delivery is a full extract of every table at a given date.

    dbt run-operation load_raw --args '{batch: batch_1}'
#}
{% macro load_raw(batch='batch_1') %}
  {% set tables = ['companies', 'contacts', 'courses', 'course_sessions', 'enrollments',
                   'invoices', 'invoice_lines', 'payments', 'evaluations'] %}
  {% do run_query('create schema if not exists raw') %}
  {% for table in tables %}
    {% set path = var('data_dir') ~ '/' ~ batch ~ '/' ~ table ~ '.csv' %}
    {% do run_query("create or replace table raw." ~ table ~ " as select *, current_timestamp as _loaded_at from read_csv('" ~ path ~ "')") %}
    {{ log('raw.' ~ table ~ ' loaded from ' ~ path, info=true) }}
  {% endfor %}
{% endmacro %}
