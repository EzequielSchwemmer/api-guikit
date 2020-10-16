module Concerns
  module CSVSerializable
    def to_csv
      CSV.generate(headers: true) do |csv|
        csv << xls_columns

        find_each(batch_size: 100) do |record|
          csv << record.xls_attributes
        end
      end
    end
  end
end
