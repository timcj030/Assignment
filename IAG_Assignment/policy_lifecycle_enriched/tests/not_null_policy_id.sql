SELECT *
FROM {{ ref('stg_policy_events') }}
WHERE PolicyId IS NULL; 