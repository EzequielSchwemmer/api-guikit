class DatabaseManager < ApplicationManager
  SPACING_ROWS = Rails.application.secrets.xls_spacing_rows
  SPACING_COLUMNS = Rails.application.secrets.xls_spacing_columns

  attr_reader :option_params

  def initialize(model_params, option_params = nil)
    super(model_params)
    @option_params = cast_options(option_params)
  end

  def build
    build_exports
  end

  private

  def cast_options(options)
    return {} if options.blank?

    date_options(options).merge(integer_options(options))
  end

  def date_options(options)
    {
      since: datetime_type.cast(options[:since]),
      upto: datetime_type.cast(options[:upto])
    }
  end

  def integer_options(options)
    {
      spacing_rows: integer_type.cast(options[:spacing_rows]),
      spacing_columns: integer_type.cast(options[:spacing_columns]),
      limit: integer_type.cast(options[:limit]),
      offset: integer_type.cast(options[:offset])
    }
  end

  def datetime_type
    @datetime_type ||= ActiveRecord::Type::DateTime.new
  end

  def integer_type
    @integer_type ||= ActiveRecord::Type::Integer.new
  end

  def build_exports
    attributes = params.merge(options: build_options)
    FakeModels::Database.new(attributes)
  end

  def build_options
    FakeModels::DatabaseOptions.new(option_attributes)
  end

  def option_attributes
    @option_attributes ||= nil_or_defaults(option_params, default_options)
  end

  def default_options
    {
      # Some arbitrary defaults, doesn't merit configurations
      since: 2.weeks.ago,
      upto: Date.current,
      spacing_rows: SPACING_ROWS,
      spacing_columns: SPACING_COLUMNS,
      limit: 100_000,
      offset: 0
    }
  end

  def nil_or_defaults(values, defaults)
    defaults.each_key.with_object({}) do |key, result|
      result[key] = values[key].nil? ? defaults[key] : values[key]
    end
  end
end
