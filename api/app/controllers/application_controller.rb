class ApplicationController < ActionController::Base
  include Pundit
  before_action :configure_permitted_parameters, if: :devise_controller?
  protect_from_forgery with: :null_session
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def not_authorized; end

  protected

  def user_not_authorized
    redirect_to '/not_authorized'
  end

  def configure_permitted_parameters
    attributes = %i[birthday name gender avatar last_name dni]
    devise_parameter_sanitizer.permit(:sign_up, keys: attributes)
    devise_parameter_sanitizer.permit(:account_update, keys: attributes)
  end

  # Overwriting the sign_out redirect path method
  def after_sign_out_path_for(_resource_or_scope)
    admin_root_path
  end
end
