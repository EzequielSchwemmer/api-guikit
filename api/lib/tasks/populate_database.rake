namespace :db do
  task populate: :environment do
    Rake::Task['db:seed:roles'].invoke
    Rake::Task['db:seed:default_admin_account'].invoke
  end
end
