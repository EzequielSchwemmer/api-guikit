# Required by Administrate to properly show in views
class DigitalizedTicket < Ticket
  self.table_name = 'tickets'

  default_scope { digitalized }
end
