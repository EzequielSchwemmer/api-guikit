# Sets up an easy admin user for tests
AdminUser.transaction do
  admin = AdminUser.find_by(email: 'admin@pyg.com')
  admin ||= AdminUser.create!(
    email: 'admin@pyg.com', password: 'aA12345678!', name: 'P&G Admin',
    birthday: 21.years.ago, role: Role.find_by!(name: 'Super Administrador')
  )
end
