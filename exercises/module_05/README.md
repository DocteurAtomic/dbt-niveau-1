# Module 5 final project: satisfaction by course

The training managers of Pachadata Training want to know, for every course of the
catalog, how many trainees evaluated it and how satisfied they were. The back office
records an evaluation at the end of a course, and the `load_raw` macro has loaded the
table `raw.evaluations` since module 1, but no model reads it yet.

This project uses everything in the course: a source, a staging model, a mart, tests, a
description, and the continuous integration of module 4.

## Start

Fork `DocteurAtomic/dbt-niveau-1` on GitHub, clone your fork, and start from the tag
`module-05-start`, with the first delivery loaded and the whole project built once:

```bash
git clone https://github.com/<your-account>/dbt-niveau-1.git
cd dbt-niveau-1
git switch -c course-satisfaction module-05-start
dbt deps
dbt run-operation load_raw --args '{batch: batch_1}'
dbt build
```

GitHub can disable the workflows of a fork. Open the Actions tab of your fork: if it
offers to enable the workflows, enable them, or the pull request will have no build.

## Look at the data first

Before writing a model, query the raw table:

```bash
dbt show --inline "select evaluation_id, enrollment_id, evaluated_at, channel, rating from raw.evaluations" --limit 5
```

Do not put a `limit` inside the inline query: `dbt show` adds its own, and the query
fails with a syntax error. Use `--limit`.

The table has one row per evaluation, `evaluation_id` is its key, and an enrollment has
at most one evaluation. The first delivery has 14886 evaluations, from 2024-01-03 to
2026-06-30. No column is empty. `rating` is the average of the answers of the evaluation
scored from 1 to 5, rounded to one decimal: it goes from 1.6 to 5.0. These are the traps
of the data:

- `raw.enrollments` has three enrollments extracted twice (module 3). Two of them have an
  evaluation: joined to the raw table, these two evaluations count twice, and the course
  181 gets 93 evaluations instead of 91. Read the enrollments through `stg_enrollments`.
- Only trainees present at a completed session evaluate it. The response rate is the
  number of evaluations divided by the attendees of the completed sessions: 14886 out of
  27254, or 0.55. Divided by all the enrollments, cancelled ones included, it falls to
  0.46. 31 completed sessions with attendees have no evaluation at all.
- An average of session averages gives a small session the same weight as a large one.
  For the course 329, the average of its twelve session averages is 4.13, and the average
  of its 47 evaluations is 4.24. Weigh each evaluation the same.
- Some courses have very few evaluations. The course 440 has four, and its average of
  4.70 puts it first of the catalog. Keep the number of evaluations next to the average.
- `channel` always has the value `WEB` in this extract: it tells nothing.
- Four courses of the catalog have no completed session. Decide whether they are in the
  mart, and say it in the description.

## What to build

1. Declare the `evaluations` table in `models/staging/_sources.yml`.
2. Write `stg_evaluations` in `models/staging/`.
3. Write `fct_course_satisfaction` in `models/marts/`, one row per course, with at least
   `course_id`, `course_title`, `evaluation_count`, `response_rate` and `avg_rating`.
   Reuse `fct_sessions` and `stg_enrollments` through `ref`.
4. Add at least one test on the mart, and describe the model and its columns in
   `models/marts/_marts.yml`.
5. Build the whole project: `dbt build`. Only the two warnings of module 3 remain.

## Open the pull request

Commit your work, push the branch to your fork, and open a pull request. GitHub proposes
the original repository as the base: choose your fork and its `main` branch instead. The
`check` workflow builds the project on the pull request.

The project is done when:

- the model `fct_course_satisfaction` exists, built from `ref` and `source`;
- it has at least one test;
- the model has a description;
- the `check` workflow is green on your pull request.

## Check your result

On the first delivery, the solution has 180 rows, one per course of the catalog, and 176
of them have an average rating. For the course 203, Linux for database administrators: 24
completed sessions, 206 attendees, 106 evaluations, a response rate of 0.51 and an
average rating of 4.68.

Compare with a query written by hand on the raw tables:

```bash
dbt show --inline "select count(*) as evaluations, round(avg(v.rating), 2) as avg_rating from raw.evaluations as v where v.enrollment_id in (select e.enrollment_id from raw.enrollments as e join raw.course_sessions as s on s.session_id = e.session_id where s.course_id = 203)"
```

It returns 106 evaluations and 4.68. The `in` reads each enrollment once, which a join
would not.

The solution is in `solution/`. Replace `models/staging/_sources.yml` with
`solution/_sources.yml`, copy `stg_evaluations.sql` into `models/staging/` and
`fct_course_satisfaction.sql` into `models/marts/`, and add the models of
`solution/_staging.yml` and `solution/_marts.yml` under `models:` in the YAML files of the
same name. With the solution, `dbt build` processes 13 models and 21 tests: 37 nodes, 34
successes, 2 warnings and 1 no-op.

## Questions

<details>
<summary>Why are the evaluations counted per session before the join?</summary>

`fct_sessions` has one row per session. Joining it to the evaluations directly would give
one row per evaluation, and the attendees of a session would be summed once per
evaluation. Counting the evaluations per session first keeps one row per session, as the
revenue of module 2 is summed per enrollment before its join.
</details>

<details>
<summary>Why is the average computed from a sum of ratings?</summary>

The solution keeps the sum of the ratings and the number of evaluations per session, and
divides the two totals per course. Each evaluation then weighs the same, whatever the
size of its session.
</details>
