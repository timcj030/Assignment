{{
    config(
        materialized='table',
        partition_by={'field': 'EventMonth', 'data_type': 'date'}
    )
}}

WITH events AS (
    SELECT * FROM {{ ref('stg_policy_events') }}
)

/*Derive First quote,First bind,First Cancel*/
,first_events AS (
    SELECT
        PolicyId /*Since I have changed policy_id to PolicyId in stg model */  
        ,EventMonth    
        ,MIN(CASE WHEN EventType = 'quote' THEN EventTs END) AS FirstQuoteTs
        ,MIN(CASE WHEN EventType = 'bind' THEN EventTs END) AS FirstBindTs
        ,MIN(CASE WHEN EventType = 'cancel' THEN EventTs END) AS FirstCancelTs
    FROM events
    GROUP BY PolicyId
)

/*Get the latest event type for each policy*/
,latest_event AS (
    SELECT
        PolicyId
        ,EventType AS CurrentStatus
    FROM events
        QUALIFY ROW_NUMBER() OVER (PARTITION BY PolicyId ORDER BY EventTs DESC) = 1
)

/*Calculate durations and also get other values in . Since the measure of duration wasn't mentioned in question, I have calculated it as hours*/
,durations AS (
    SELECT
        FTE.PolicyId
        ,FTE.EventMonth
        ,FTE.FirstQuoteTs
        ,FTE.FirstBindTs
        ,FTE.FirstCancelTs
        ,LTE.CurrentStatus        
        ,TIMESTAMP_DIFF(FTE.first_bind_ts, FTE.first_quote_ts, HOUR) AS QuoteToBindHrs
        ,TIMESTAMP_DIFF(FTE.first_cancel_ts, FTE.first_bind_ts, HOUR) AS BindToCancelHrs
    FROM first_events FTE
        LEFT JOIN latest_event LTE ON FTE.PolicyId = LTE.PolicyId
)

SELECT * FROM durations 


