class ModelFinder
  # Warning: This operation is time consuming
  def application_models
    return @application_models if @application_models.present?

    # Force rails to load all classes
    Rails.application.eager_load!
    # This returns all direct descendants of ApplicationRecord
    @application_models = ApplicationRecord.descendants.filter do |model|
      # Only get descendants of ApplicationRecord
      model.superclass == ApplicationRecord && !model.abstract_class
    end
  end

  def model_keys
    @model_keys ||= application_models.map(&method(:model_key_for)).sort
  end

  def select_models(selected_params)
    application_models.filter { |model| selected?(selected_params, model) }
  end

  private

  def selected?(selected_params, model)
    value = selected_params[model_key_for(model)]
    boolean_type.cast(value)
  end

  def model_key_for(model)
    model.name.underscore
  end

  def boolean_type
    @boolean_type ||= ActiveRecord::Type::Boolean.new
  end
end
