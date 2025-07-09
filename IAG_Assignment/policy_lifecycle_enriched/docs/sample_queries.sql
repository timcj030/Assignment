/*Answers to sample queries*/

-- 1. Number of policies that were quoted but never bound
SELECT 
    COUNT(*) AS QuotedNotBoundNo
FROM {{ ref('policy_lifecycle_enriched') }}
WHERE FirstQuoteTs IS NOT NULL AND FirstBindTs IS NULL;


-- 2. Average time from quote to bind per month
SELECT 
    EventMonth
    ,AVG(QuoteToBindHrs) AS AvgQuoteToBindHrs
FROM {{ ref('policy_lifecycle_enriched') }}
WHERE QuoteToBindHrs IS NOT NULL
GROUP BY EventMonth
ORDER BY EventMonth;


-- 3. Total number of policies cancelled within 30 days of binding
SELECT 
    COUNT(*) AS num_cancelled_within_30_days
FROM {{ ref('policy_lifecycle_enriched') }}
WHERE BindToCancelHrs IS NOT NULL AND BindToCancelHrs <= 24*30; 


/*Some more sample queries from my side for BI Analysis*/


/*1. Count of Policies by Status*/
SELECT 
    CurrentStatus
    ,COUNT(*) AS NumPolicies
FROM {{ ref('policy_lifecycle_enriched') }}
GROUP BY CurrentStatus
ORDER BY NumPolicies DESC;


/*2. Top 10 Fastest policies from Bind to Cancel*/
SELECT 
    PolicyId
    ,BindToCancelHrs
FROM {{ ref('policy_lifecycle_enriched') }}
WHERE BindToCancelHrs IS NOT NULL
ORDER BY BindToCancelHrs ASC
LIMIT 10;