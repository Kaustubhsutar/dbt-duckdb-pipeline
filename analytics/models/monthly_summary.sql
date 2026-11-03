WITH total_job_postings AS (
    SELECT
        month,
        SUM(postings) AS total_postings
    FROM {{ ref('jobs_per_month') }}
    GROUP BY month
),
total_remote_postings AS (
    SELECT
        DATE_TRUNC('month', search_date) AS month,
        COUNT(*) AS remote_postings
    FROM {{ ref('job_postings') }}
    WHERE job_work_from_home
    GROUP BY month
)

SELECT
    total_postings,
    remote_postings,
    ROUND((remote_postings/ total_postings) * 100, 1) AS remote_pct
FROM total_job_postings
JOIN total_remote_postings USING (month)
ORDER BY month;