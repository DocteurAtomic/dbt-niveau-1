# Module 3 exercise: test and document the payments

The finance team reads `fct_payments`, the incremental model of module 3. Nothing checks
it yet, and its documentation page is empty.

Start from the tag `module-03-end`, with the first delivery loaded and the whole project
built once:

```bash
git switch -c exercise-03 module-03-end
dbt run-operation load_raw --args '{batch: batch_1}'
dbt build
```

## What to build

1. In `models/marts/_marts.yml`, add `fct_payments` with a description, and describe
   `payment_id`, `invoice_id`, `payment_date`, `amount` and `payment_method_code`.
2. Add generic tests: `payment_id` is unique and not null, `payment_method_code` only
   takes `TRANSFER`, `CHECK`, `CARD` or `DIRECT_DEBIT`, and every `invoice_id` exists in
   `stg_invoices`.
3. Write a singular test, `tests/assert_payment_not_before_invoice.sql`: a payment cannot
   be dated before the invoice it pays.
4. Build the model and its tests: `dbt build --select +fct_payments`. Your tests pass on
   the first delivery; the warning on `assert_invoice_has_lines` is the one of the module.

## Check the incremental model

1. Load the second delivery and build the model again:
   `dbt run-operation load_raw --args '{batch: batch_2}'`, then
   `dbt build --select fct_payments`. Count the rows of `fct_payments`.
2. Load the first delivery again and rebuild the model. How many rows now? Which test
   fails, and why?
3. Rebuild it with `--full-refresh`. How many rows?

Expected counts: 22147 payments in the first delivery, 24020 in the second.

## Check your documentation

Run `dbt docs generate` and `dbt docs serve`, and open the page of `fct_payments`.

The solution is in `solution/`: add the model of `_marts.yml` under `models:` in
`models/marts/_marts.yml`, and copy the singular test into `tests/`.

## Answers

<details>
<summary>Reloading the first delivery</summary>

The table keeps its 24020 rows: an incremental model adds rows, it never removes the
ones that are no longer in the source. The relationships test on `invoice_id` fails with
897 rows, the payments of the second delivery whose invoice is not in the first one.
`--full-refresh` rebuilds the table from the source: 22147 rows, and the test passes.
</details>
