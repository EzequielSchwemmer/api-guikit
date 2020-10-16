# Required by Administrate to properly show in views
class UnsegmentedTicket < Ticket
  self.table_name = 'tickets'

  default_scope { unsegmented }
end
