Devise.setup do |config|

  # Timeoutable configuration
  # Note: P&G Accounts doesn't need timeout in accounts, only on developer's pc sessions.
  config.secret_key = Rails.application.secrets.secret_key_base

  # Lockeable configuration
  # Failed attempts to log in results in an instant lock of the account
  config.lock_strategy = :failed_attempts
  config.unlock_keys = [ :email ]
  config.strip_whitespace_keys = [:email]
  config.unlock_strategy = :email
  config.maximum_attempts = 5
  config.last_attempt_warning = true
  config.timeout_in = 2000.years
  config.mailer_sender = Rails.application.secrets.mailer_username

  require 'devise/orm/active_record'

  config.stretches = Rails.env.test? ? 1 : 10
  config.password_length = 6..128
  config.sign_out_via = :delete
end
