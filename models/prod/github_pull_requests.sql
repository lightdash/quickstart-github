{{
  config(
    materialized='table',
    schema='prod',
    tags=['prod', 'nightly']
  )
}}

with issues as (
    select * from {{ ref('base_github_issue') }}
),

creators as (
    select * from {{ ref('base_github_user') }}
),

pull_requests as (
    select * from {{ ref('base_github_pull_request') }}
),

issue_merged as (
  select * from {{ ref("base_github_issue_merged") }}
),

repositories as (
  select * from {{ ref('base_github_repository') }}
),

lightdash_team_memberships as (
  select * from {{ ref("stg_github_lightdash_team_memberships") }}
),

final AS (
    SELECT
      issues.id,
      issues.closed_at,
      issues.created_at,
      issues.number as pull_request_number,
      issues.state,
      issues.title,
      issues.updated_at,
      repositories.full_name as repository,
      CONCAT("https://github.com/", repositories.full_name, "/pull/", CAST(issues.number as string)) as url_link,
      issue_merged.merged_at,
      issue_merged.merged_at is not null as is_merged,
      IF(issue_merged.merged_at is null, null, TIMESTAMP_DIFF(issue_merged.merged_at, issues.created_at, SECOND) / 60 / 60) as cycle_time_hours,
      merger.login as merged_by,
      merger.type as merger_type,
      creators.login as created_by,
      creators.type as creator_type,
      lightdash_team_memberships.user_id is not null as created_by_lightdash_team
    FROM 
      issues
    inner join repositories
      on repositories.id = issues.repository_id
    left join issue_merged
      on issues.id = issue_merged.issue_id
    left join creators as merger
      on issue_merged.actor_id = merger.id
    left join creators
      on issues.user_id = creators.id
    left join lightdash_team_memberships
      on creators.id = lightdash_team_memberships.user_id
    WHERE
        pull_request
)

SELECT * FROM final