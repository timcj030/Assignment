## policy_lifecycle_enriched

This dbt project is for analyzing policy life cycle events from quote to bind to cancel

## Setup
1. Place BigQuery service account key file in secret manager
2. Edit `profiles.yml` and set the `keyfile` path to service account key.
3. Set BigQuery project to `iag_test` and dataset to `policy_lifecycle` 

## Running dbt

To use the local `profiles.yml`, run dbt commands with the `--profiles-dir` flag:

```sh
dbt run --project-dir . --profiles-dir .
dbt test --project-dir . --profiles-dir .
dbt seed --project-dir . --profiles-dir .
```

## Project Structure
- `models/` - dbt models (staging and marts)
- `seeds/` - Seed CSV files
- `tests/` - Data tests
- `docs/` - Documentation and BI query examples
- `profiles.yml` - dbt profile for BigQuery 
