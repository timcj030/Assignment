{{
  config(
    materialized='table'
  )
}}
/*I have moved the csv file to seed folder, when we run "dbt seed" it will create a table in db with the same name which will be referred below*/
WITH polevnt AS (
    SELECT * FROM {{ ref('policy_events') }}
)

/* I will do some cleaning of data as mentioned in the document*/
,cleaned AS (
    SELECT
        policy_id
        ,event_type
        /*To handle Missing/invalid timestamps I'm using SAFE.PARSE_TIMESTAMP, this will return null if the timestamp is invalid*/
        ,SAFE.PARSE_TIMESTAMP('%Y-%m-%d %H:%M:%S', event_timestamp) AS event_timestamp
        ,source_channel
        ,state
        ,product_type
        ,SAFE_CAST(premium_amount AS FLOAT64) as premium_amount /*Keeps the amount in num format */
        /*I need to get event_month which is needed for partitioning as mentioned in the question*/
        ,DATE_TRUNC(DATE(SAFE.PARSE_TIMESTAMP('%Y-%m-%d %H:%M:%S', event_timestamp)), MONTH) AS EventMonth  
        /*to handle duplicate as metioned in question, I will use rownumber*/
        ,ROW_NUMBER() OVER (PARTITION BY policy_id, event_type ORDER BY event_timestamp) AS rn
    FROM polevnt
    WHERE policy_id IS NOT NULL -/*This not null condition is added since I saw some rows with null policy_id*/
)

/* Now will dedupe the dataset*/
,deduped AS (
    SELECT * FROM cleaned WHERE rn = 1
)

/*Get deduped-cleaned data*/

/* ***NOTE*** - I'm changing the fieldnames to PascalCase just as a best practice which I followed for long :). I can keep this in the same _ format
with all small letters if the company standard is like that*/
SELECT
    policy_id AS PolicyId
    ,event_type AS EventType
    ,event_timestamp AS EventTs
    ,source_channel AS SourceChanel
    ,state AS State
    ,product_type AS ProductType
    ,premium_amount AS PremiumAmount
    ,event_month AS EventMonth
FROM deduped
