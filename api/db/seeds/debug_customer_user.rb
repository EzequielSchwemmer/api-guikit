# Sets up an easy customer user for tests
user = User.find_by(email: 'customer@pyg.com')
user ||= User.create!(
  email: 'customer@pyg.com', password: 'aA12345678!', name: 'P&G Customer',
  birthday: 21.years.ago
)

5.times do |n|
  ticket = FactoryBot.create(:ticket, :with_pictures, user: user)
  Reward.create!(user: user, ticket: ticket, points: n)
  UserDiscount.create!(discount: FactoryBot.create(:discount), user: user)
  TicketDiscount.create!(discount: FactoryBot.create(:discount), ticket: ticket)
end
