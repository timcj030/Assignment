SELECT PolicyId, COUNT(*)
FROM {{ ref('policy_lifecycle_enriched') }}
GROUP BY PolicyId
HAVING COUNT(*) > 1; 