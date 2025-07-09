SELECT * 
FROM {{ref('stg_policy_events')}} 
WHERE EventTs IS NULL