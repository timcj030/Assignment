SELECT *
FROM {{ ref('policy_lifecycle_enriched') }}
WHERE CurrentStatus NOT IN ('quote', 'bind', 'cancel'); 