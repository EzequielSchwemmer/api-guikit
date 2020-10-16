class DigitalizedTicketDashboard < UploadedTicketDashboard
  SHOW_PAGE_ATTRIBUTES = %i[
    ticket_code
    retailer_name
    branch_name
    total
  ].freeze

  def resource_icon
    'pencil-square-o'
  end
end
