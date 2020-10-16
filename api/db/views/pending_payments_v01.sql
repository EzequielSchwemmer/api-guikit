SELECT
  MAX(id) as id,
  user_id,
  NULL as deleted_at
FROM tickets
WHERE tickets.status = 3 /* approved */
GROUP BY tickets.user_id
