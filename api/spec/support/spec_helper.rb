require 'simplecov'
SimpleCov.start
require 'factory_bot'
require 'faker'
require 'rake'

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  Faker::Config.random = Random.new(config.seed)

  config.before(:all) do
    FactoryBot.reload
  end

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
    Rake::Task['db:populate'].invoke
    allow_any_instance_of(SNS).to receive(:destroy_topic).and_return(nil)
    allow_any_instance_of(SNS).to receive(:create_topic).and_return(double(topic_arn: 'arn',
                                                                     endpoint_arn: 'arn',
                                                                     subscription_arn: 'arn')) 
  end

  config.after(:each) do
    DatabaseCleaner.clean
    Timecop.return
  end
end
