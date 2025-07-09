# Documentation

#Overview
This dbt pipeline processes raw policy_event data from a CSV seed, stages and cleans it, and produces a final model: `policy_lifecycle_enriched`.

1. Project Setup
================
- I have initialized this as a dbt project with normal dbt folder structure: models (with staging and marts), seeds, tests, and docs, analysis, macros etc. To keep the folder structure I have added .gitkeep where there is no other files in the folder
- We can mention BigQuery connection  in `profiles.yml` . I have used project: iag_test, dataset: policy_lifecycle .authentication is done through service account, I didn't mention it there as I don't have the proj set up in my laptop and mine was expired for most of my email ids :)

2.Seed Folder
===============
-  I have moved the `policy_events.csv` in the `seeds/` directory. From there We can load it to Bq by running 'dbt seed' command as mentioned in Readme.md. This will create a table in BigQuery which serves as the source for stg_policy_events.sql

3.Staging Folder
================
-It contains the model `stg_policy_events` materialized as a table
- Cleaned and deduplicated the raw data.
- Parsed timestamps, converted amount and EventMonth to proper datatype, and removed invalid or missing timestamps.
- Added a new column `EventMonth` which is used for partition as mentioned in the question.

4. Final Model (marts folder)
=========================================
- Model name is `policy_lifecycle_enriched`. This also materialized as table
- In this model I have done the following 
- Created FirstQuoteTs, FirstBindTs, FirstCancelTs columns
- Derived CurrentStatus, QuoteToBindHrs,BindToCancelHrs
- Also partitioned by EventMonth

5. Edge Cases
======================================
- Duplicates are removed 
- Ordered by timestamp to order the events for each policy
- Deleted Rows with missing timestamps 

6. Tests Performed (in tests folder)
==============================
- Valid event timestamp(event_timestamp_valid.sql)
- Policies quoted but not bounded for more than 7  days (long_quote_to_bind.sql)
- Policies quoted but not yet bounded (missing_bind_event.sql)
- Policies bounded but not yet canceled (missing_cancel_event.sql) 
- No duplicate policy in final table (no_duplicate_policies.sql)
- Not null Policy Id(not_null_policy_id.sql)
- Valid Current Status (valid_status_values.sql)

7.Sample Queries for BI
========================
I have added answers to sample_queries and also another 2 in sample_queries.sql under docs folder

8.Answers to Question
======================
I have added a file named Answers_to_Question.md to answer some of the questions asked 



