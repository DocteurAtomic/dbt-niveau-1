# Pachadata Training data

Pachadata Training is a fictional training company. These files are two deliveries of its
back office, each one a full extract of every table at a given date:

| Folder | Extract date |
|---|---|
| `batch_1` | 2026-06-30 |
| `batch_2` | 2026-09-30 |

Between the two dates, sessions move from `OPEN` to `COMPLETED`, new enrollments, invoices
and payments arrive, and some enrollments are cancelled. The course uses this to show
source freshness, incremental models and snapshots.

All people, companies and email addresses are fictional. Email domains end in `.example`,
a top-level domain reserved for documentation (RFC 2606).

## Tables

| Table | Grain | Key |
|---|---|---|
| `companies` | one client company | `company_id` |
| `contacts` | one trainee | `contact_id` |
| `courses` | one course of the catalog | `course_id` |
| `course_sessions` | one scheduled session of a course | `session_id` |
| `enrollments` | one trainee in one session | `enrollment_id` |
| `invoices` | one invoice | `invoice_id` |
| `invoice_lines` | one line of an invoice | `invoice_id`, `line_number` |
| `payments` | one payment received for an invoice | `payment_id` |
| `evaluations` | one end-of-course evaluation | `evaluation_id` |

## Known data quality issues

The extract has defects on purpose, for the tests of module 3 to find. Do not fix them in
the files: fix them, or flag them, in the dbt project.

- Three enrollments are extracted twice (same row, twice).
- In `batch_2`, two enrollments point to a session that does not exist.
- One invoice has no lines.
- In `batch_2`, one session has the status `POSTPONED`, which the back office does not
  define.
- Some contacts have no email, and some have no company.

## Origin

Extracted from PachaDataFormation, the demonstration database of Pachadata, then
translated into English. See the course on https://www.docteuratomic.com.
