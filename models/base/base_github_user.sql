{{
  config(
    materialized='incremental',
    schema='base',
    tags=['base', 'nightly']
  )
}}

SELECT
*,
CURRENT_DATE() AS contributor_created_date

FROM `lightdash-raw-events.github.user`

{% if is_incremental() %}

  -- this filter will only be applied on an incremental run
  where id NOT IN(select id from {{ this }})

{% endif %}
