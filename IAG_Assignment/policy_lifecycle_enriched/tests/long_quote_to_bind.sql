/* Test if the quote to bind is more than 7 days*/

SELECT * 
FROM {{ref('policy_lifecycle_enriched')}} 
WHERE QuoteToBindHrs > 168