class ApiController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  include Pundit
  include Pagy::Backend

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from ActiveRecord::RecordInvalid, with: :invalid_record
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  before_action :authenticate_user!
  before_action :set_locale

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    { locale: locale }
  end

  # for devise to redirect with locale
  def self.default_url_options(options = {})
    options.merge(locale: I18n.locale)
  end

  # Allow audited to use a custom user based on the controller
  def audited_user
    current_user
  end

  private

  def not_found
    render json: { data: { type: 'not_found',
                           attributes: { id: params[:id] },
                           errors: [
                             I18n.t(:record_not_found, scope: %i[activerecord errors messages])
                           ] } },
           status: :not_found
  end

  def user_not_authorized
    render json: { data: { type: 'role_change',
                           attributes: { user_id: params[:id] },
                           errors: [I18n.t(:default, scope: %i[pundit])] } },
           status: :forbidden
  end

  def invalid_record(invalid)
    render json: { data: { type: 'invalid_record',
                           attributes: invalid.record,
                           errors: invalid.record.errors.full_messages } },
           status: :precondition_failed
  end

  def authenticate_user!
    return if current_user

    render json: { data: { type: 'session',
                           errors: [
                             I18n.t(:not_authenticated, scope: %i[devise_token_auth sessions])
                           ] } },
           status: :unauthorized
  end
end
