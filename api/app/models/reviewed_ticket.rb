# Required by Administrate to properly show in views
class ReviewedTicket < Ticket
  self.table_name = 'tickets'

  default_scope { reviewed }
end
