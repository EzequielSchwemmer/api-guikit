# This are created only for testing purposes,
# This seed should not be used in production

ApplicationRecord.transaction do
  # Create 5 tickets for testing
  5.times do
    ticket = TicketManager.new(User.first).build
    Dir[Rails.root.join('spec', 'support', 'fixtures', 'ticket', '*.{png,jpg,jpeg}')].each do |pic|
      File.open(pic) do |io|
        ticket.pictures.attach(
          io: io,
          filename: File.basename(pic)
        )
        # it saves each file separately to prevent file descriptor problems
        ticket.save!        
      end
    end
  end
end
