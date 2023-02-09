# quickstart-github

Instant analytics for Github

### Extract github data

The models is the `/models/base` directory assume that [Fivetran](https://www.fivetran.com) has been used to extract the data

### Models

- `base` are base models created by fivetran
- `stg` are reusable models with intermediate transformations
- `prod` are analytics ready tables for Lightdash to consume

### Metrics

See `/models/prod/github_pull_requests` for metric definitions
