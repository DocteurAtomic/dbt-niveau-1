# Module 2 exercise: revenue by client company

The sales team wants, for every client company, the number of trainees it sent and the
training revenue invoiced for them.

Start from the tag `module-02-end`:

```bash
git switch -c exercise-02 module-02-end
dbt run-operation load_raw --args '{batch: batch_1}'
```

## What to build

1. Declare the `contacts` and `companies` tables in `models/staging/_sources.yml`.
2. Write `stg_contacts` and `stg_companies` in `models/staging/`.
3. Write `fct_company_revenue` in `models/marts/`, one row per company, with
   `company_id`, `company_name`, `country_code`, `trainee_count` (distinct contacts with at
   least one enrollment), `enrollment_count` and `training_revenue`. Reuse
   `int_enrollment_revenue` through `ref`.
4. Build only your mart and what it depends on: `dbt build --select +fct_company_revenue`.

## Check your result

- `fct_company_revenue` has one row per company that has at least one enrolled contact.
- Contacts without a company are not in the mart. How many enrollments does that leave
  out? Write the query.
- `dbt compile --select fct_company_revenue` and read the SQL in `target/compiled/`.

The solution is in `solution/`. Copy its files into `models/` to compare.
