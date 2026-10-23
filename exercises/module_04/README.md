# Module 4 exercise: payments by method, in the prod target

The finance team wants the amount received each year, excluding tax, split by payment
method, and it reads the prod database, not your dev file.

Start from the tag `module-04-end`, with the first delivery loaded and the whole project
built once:

```bash
git switch -c exercise-04 module-04-end
dbt run-operation load_raw --args '{batch: batch_1}'
dbt build
```

## What to build

1. In `macros/amounts.sql`, next to `to_incl_tax`, write a macro
   `to_excl_tax(amount_incl_tax, vat_rate)` that converts an amount including tax into an
   amount excluding tax, rounded to the cent. A VAT rate is stored as a percentage
   (`20.00`).
2. Write the model `models/marts/fct_yearly_payments_by_method.sql`: one row per year of
   `payment_date`, and one column per payment method, `<method>_amount_excl_tax`, plus a
   `total_amount_excl_tax`. Payments come from `fct_payments`, their VAT rate from the
   invoice they pay (`stg_invoices`). Do not write the methods by hand: read them with
   `dbt_utils.get_column_values` on `stg_payments`, and loop over them.
3. In `models/marts/_marts.yml`, describe the model and test that `payment_year` is unique
   and not null.
4. Run `dbt compile --select fct_yearly_payments_by_method` and read the compiled SQL in
   `target/compiled/`: one `sum(...) filter (...)` per method.

## Build it in prod

The `prod` target of `profiles.yml` writes to `pachadata_prod.duckdb`, which starts empty.

```bash
dbt run-operation load_raw --args '{batch: batch_1}' --target prod
dbt build --target prod
```

Build the whole project: a selection such as `--select +fct_yearly_payments_by_method`
also runs the singular test `assert_invoice_has_lines`, which reads `stg_invoice_lines`,
and that model does not exist yet in a new prod database.

Then read the result in prod:

```bash
dbt show --target prod --inline "select * from {{ ref('fct_yearly_payments_by_method') }} order by payment_year"
```

Expected on the first delivery: four years, 2023 to 2026, and a total of 51978765.49
over the four years. 2023 has no card payment, so its `card_amount_excl_tax` is null.

The solution is in `solution/`: replace `macros/amounts.sql` with `solution/amounts.sql`,
copy the model into `models/marts/`, and add the model of `solution/_marts.yml` under
`models:` in `models/marts/_marts.yml`.

## Questions

<details>
<summary>Why is the total not exactly the sum of the amounts divided by 1.2?</summary>

The macro rounds each payment to the cent before the sum. Dividing the sum of the amounts
by their VAT rate without rounding gives 51978765.25: the 0.24 of difference is the sum of
22147 roundings. Some invoices also have a VAT rate of 0, so dividing everything by 1.2
would be wrong.
</details>

<details>
<summary>What happens if a fifth payment method appears in a new delivery?</summary>

The next compilation reads it from `stg_payments`, and the model gets a fifth column
without any change to its code. With a list written by hand, the new method would only
appear in `total_amount_excl_tax`.
</details>
