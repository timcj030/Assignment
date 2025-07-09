SELECT * 
FROM {{ref('policy_lifecycle_enriched')}} 
WHERE FirstQuoteTs IS NOT NULL AND FirstBindTs IS NULL