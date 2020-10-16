require 'administrate/base_dashboard'

class ApplicationDashboard < Administrate::BaseDashboard
  SINGULAR_COUNT = 1
  EDIT_ATTRIBUTES = [].freeze
  PASSWORD_ATTRIBUTES = %i[password password_confirmation].freeze
  DISPLAY_NAME_MAX_LENGTH = 40

  def display_resource(resource)
    model = resource.class
    I18n.t("activerecord.models.#{model.model_name.i18n_key}", count: SINGULAR_COUNT)
  end

  def resource_icon
    'circle'
  end

  def edit_attributes(resource)
    self.class::EDIT_ATTRIBUTES.map { |attribute| attribute_field(resource, attribute, :form) }
  end

  def change_password_attributes(resource)
    self.class::PASSWORD_ATTRIBUTES.map { |attribute| attribute_field(resource, attribute, :form) }
  end

  protected

  def attribute_field(resource, attribute_name, page)
    value = get_attribute_value(resource, attribute_name)
    field = attribute_type_for(attribute_name)
    field.new(attribute_name, value, page, resource: resource)
  end

  def get_attribute_value(resource, attribute_name)
    resource.public_send(attribute_name)
  rescue NameError
    nil
  end

  def display_name(name)
    return name if name.length < DISPLAY_NAME_MAX_LENGTH

    "#{name[0...(DISPLAY_NAME_MAX_LENGTH - 3)]}..."
  end
end
