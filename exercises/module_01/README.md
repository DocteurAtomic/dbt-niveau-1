# Module 1 exercise: compiled SQL and a broken profile

Two short tasks on the project as it is at the start of the course. You write no model.

Start from the tag `module-01-start`, with the first delivery loaded:

```bash
git switch -c exercise-01 module-01-start
dbt run-operation load_raw --args '{batch: batch_1}'
dbt build
```

## Part 1: read the SQL that dbt sends

1. Run `dbt compile --select course_catalog`.
2. Open `target/compiled/pachadata_training/models/example/course_catalog.sql` and compare it
   with `models/example/course_catalog.sql`.

Answer these questions:

- What did each `source()` call become? Name the three parts of each object name.
- Where does the first part, `pachadata`, come from? Look at `profiles.yml`.
- Open the file of the same name under `target/run/`. Which statement did dbt add around
  your `select`, and which name does it give to the view it creates first?

## Part 2: repair a broken profile

`profiles.yml` in this folder has three mistakes. Copy it over the project's own file:

```bash
cp exercises/module_01/profiles.yml profiles.yml
```

Then run `dbt debug`, read the error, fix one mistake in `profiles.yml`, and run
`dbt debug` again, until it says `All checks passed!`. Then run `dbt build`.

- `dbt debug` reports two of the three mistakes. Which one does it let through, and which
  command finds it?
- After you fixed everything, run `git status --short` and `ls pachadata*.duckdb`. A file
  appeared that Git does not show. Why?

When `dbt build` succeeds, restore the original file with `git checkout profiles.yml`, and
delete the extra DuckDB file.

The solution is in `solution/`.
