{{
  config(
    materialized='table',
    schema='staging',
    tags=['staging', 'nightly']
  )
}}

with teams as (
    SELECT
      id,
      name
    FROM
      {{ ref("base_github_team")}}
),

memberships as (
    select
      team_id,
      user_id
    from
      {{ ref("base_github_team_membership")}}
),

final as (
    select
        memberships.user_id
    from memberships
    inner join teams
      on teams.id = memberships.team_id
    where
      teams.name = "Lightdash team"
)

select * from final