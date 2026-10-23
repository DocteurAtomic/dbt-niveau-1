# Module 1 exercise: solution

Measured with `dbt-oss` 2.0.8 on the first delivery.

## Part 1

Each `source()` call became a full object name in three parts, database, schema and table:

| In the model | In `target/compiled/` |
|---|---|
| `{{ source('raw', 'courses') }}` | `"pachadata"."raw"."courses"` |
| `{{ source('raw', 'course_sessions') }}` | `"pachadata"."raw"."course_sessions"` |

`pachadata` is the name DuckDB gives to the database of the file `pachadata.duckdb`, the
`path` of the `dev` target in `profiles.yml`. `raw` is the `schema` declared for the source
in `models/example/_sources.yml`.

The file under `target/run/` wraps the `select` in a `create view` statement. The view is
first created under a temporary name:

```sql
create view "pachadata"."main"."course_catalog__dbt_tmp" as (
```

With `dbt build --log-level debug`, you can see the rest of the sequence when the view
already exists: the old view is renamed `course_catalog__dbt_backup`, the temporary one is
renamed `course_catalog`, then the backup is dropped.

## Part 2

The three mistakes, in the order `dbt debug` reports them:

1. The profile is named `pachadata-training`, with a hyphen, while `dbt_project.yml` asks for
   `pachadata_training`:

   ```text
   [error] [IoError (dbt1001)]: Profile 'pachadata_training' not found in profiles.yml
     --> dbt_project.yml:3:10
   ```

2. The default target is `production`, and the profile only defines `dev`:

   ```text
   [error] [InvalidConfig (dbt1005)]: target 'production' not found in profile 'pachadata_training'
   ```

3. The `path` is `pachadata_dev.duckdb`. `dbt debug` does not see this one: it says
   `All checks passed!`, because DuckDB creates an empty file when it opens a path that does
   not exist, and the connection test succeeds. `dbt build` finds it:

   ```text
   Catalog Error: Table with name "raw.courses" does not exist because schema "raw" does not exist.
   ```

   The fix is `path: pachadata.duckdb`, the file where `load_raw` put the data.

`git status --short` shows only `profiles.yml` as modified. The new `pachadata_dev.duckdb`
is not shown because `.gitignore` ignores `pachadata*.duckdb`: database files never go into
the repository.

The repaired file is `profiles.yml` in this folder, identical to the project's own file.
