Devise.setup do |config|
  # P&G Accounts doesn't allow to use the last 8 passwords of the user
  config.password_complexity = { digit: 1, lower: 0, symbol: 0, upper: 0 }
  config.password_archiving_count = 8
  config.deny_old_passwords = true
end
