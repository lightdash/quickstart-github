{{
  config(
    materialized='table',
    schema='base',
    tags=['base', 'nightly']
  )
}}

SELECT
*

FROM `lightdash-raw-events.github.pull_request`
