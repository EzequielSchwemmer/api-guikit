def load_fixture(file_name)
  File.read(Rails.root.join('spec', 'support', 'fixtures', "#{file_name}.json"))
end
