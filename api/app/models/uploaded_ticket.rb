# Required by Administrate to properly show in views
class UploadedTicket < Ticket
  self.table_name = 'tickets'

  default_scope { uploaded }
end
