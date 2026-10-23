{% docs fill_rate %}
Enrollments that are not cancelled, divided by the maximum number of trainees of the
course (max_attendees), rounded to two decimals.

A value above 1 means the session took more trainees than the catalog allows. In the
first delivery, 280 sessions are in that case: the back office does not block it.
{% enddocs %}

{% docs training_revenue %}
Sum of the TRAINING invoice lines of the enrollments of the session, excluding tax.
Meals, printed material and administrative fees are not included.

Lines are summed per enrollment before the join (int_enrollment_revenue), so that an
enrollment with several lines is counted once.
{% enddocs %}
