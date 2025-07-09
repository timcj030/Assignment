SELECT * 
FROM {{ref('policy_lifecycle_enriched')}} 
WHERE FirstBindTs IS NOT NULL AND FirstCancelTs IS NULL