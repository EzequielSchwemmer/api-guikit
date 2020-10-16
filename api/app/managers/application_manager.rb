class ApplicationManager
  # TODO: Decide which normalization steps are we going to use in the final build
  NORMALIZATION_STEPS = %i[
    remove_dots convert_characters normalize_spacing find_similar
  ].freeze

  REMOVE_DOTS_REGEXP = /\.[\s\t]*/.freeze
  NORMALIZE_SPACE_REGEXP = /[\s\t]+/.freeze

  attr_reader :params

  def initialize(params = nil)
    @params = params
  end

  protected

  def normalize_text(text, column: :name, collection:)
    return if text.blank?

    normalization_steps.reduce(text) do |new_text, step|
      step.call(new_text, column: column, collection: collection)
    end
  end

  private

  def normalization_steps
    NORMALIZATION_STEPS.map(&method(:method))
  end

  def remove_dots(text, **_kwargs)
    text.gsub(REMOVE_DOTS_REGEXP, '')
  end

  def normalize_spacing(text, **_kwargs)
    text.gsub(NORMALIZE_SPACE_REGEXP, ' ')
  end

  def convert_characters(text, **_kwargs)
    text.humanize.upcase
  end

  def find_similar(text, column:, collection:)
    similar = collection.where("lower(#{safe_name(column)}) = lower(?)", text).pluck(column).first
    return similar if similar.present?

    text
  end

  def safe_name(column)
    ActiveRecord::Base.connection.quote_column_name(column)
  end
end
