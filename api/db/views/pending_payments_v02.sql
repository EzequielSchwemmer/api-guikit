SELECT 
  MAX(tickets.id) as id,
  tickets.user_id,
  users.deleted_at 
FROM tickets 
INNER JOIN users ON tickets.user_id=users.id 
WHERE tickets.status = 3 AND users.deleted_at IS NULL 
GROUP BY tickets.user_id, users.deleted_at
