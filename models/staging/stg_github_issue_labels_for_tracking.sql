{{
  config(
    materialized='table',
    schema='staging',
    tags=['staging', 'nightly']
  )
}}

WITH label_ids AS (
  SELECT
  name AS label_name,
  id AS label_id

  FROM {{ ref("base_github_label")}}

  WHERE id IN (
    2836472477, -- documentation
    2836472483, -- feature request
    3246500428, -- backend
    3246498968, -- frontend
    3407486160, -- devx
    3416364333, -- tech debt
    2836472473, -- bug
    3543479722 -- ux
  )
)

SELECT
issue.id AS issue_id,
issue_label.label_id,
label_ids.label_name

FROM {{ ref("base_github_issue")}} AS issue

LEFT JOIN {{ ref("base_github_issue_label")}} AS issue_label ON issue_label.issue_id = issue.id

INNER JOIN label_ids ON label_ids.label_id = issue_label.label_id

