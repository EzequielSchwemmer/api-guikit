module FakeModels
  class DatabaseOptions < Base
    class <<self
      def model_name
        @model_name ||= ActiveModel::Name.new(self, nil, 'Options')
      end
    end

    attr_accessor :since, :upto, :spacing_rows, :spacing_columns, :limit, :offset

    validates :spacing_columns, :spacing_rows, :limit, :offset,
              numericality: { only_integer: true }
    validates :since, :upto,
              timeliness: { on_or_before: :today, type: :date, message: :before_today }

    validates :since, timeliness: { on_or_before: :upto, type: :date, message: :before_upto }
    validates :upto, timeliness: { on_or_after: :since, type: :date, message: :after_since }

    validates :spacing_columns, :spacing_rows, :offset,
              numericality: { greater_than_or_equal_to: 0 }
    validates :limit, inclusion: { in: 1..100_000 }, allow_blank: true
  end
end
