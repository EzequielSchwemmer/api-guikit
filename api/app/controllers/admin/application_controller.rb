# All Administrate controllers inherit from this `Admin::ApplicationController`,
# making it the ideal place to put authentication logic or other
# before_actions.
#
# If you want to add pagination or other controller-level concerns,
# you're free to overwrite the RESTful controller actions.
module Admin
  class ApplicationController < Administrate::ApplicationController
    SINGULAR_COUNT = 1

    include Administrate::Punditize
    before_action :authenticate_admin_user!

    # Allow audited to use a custom user based on the controller
    def audited_user
      current_admin_user
    end

    # Override this value to specify the number of elements to display at a time
    # on index pages. Defaults to 20.
    # def records_per_page
    #   params[:per_page] || 20
    # end

    def after_sign_in_path_for(user)
      user.has_any_role?(:admin, :super_admin) ? admin_root : super
    end

    def after_sign_out_path_for(scope)
      case scope
      when :user
        new_user_session_path
      when :admin_user
        new_admin_user_session_path
      else
        super
      end
    end

    # Required by Administrate
    def admin_old_passwords_path
      admin_user_password_path
    end

    def pundit_user
      current_admin_user
    end

    # This is used by Administrate to display actions.
    # The original code for some odd reason didn't use active record keys for translations
    def translate_with_resource(key)
      t(
        "administrate.controller.#{key}",
        resource: translated_resource
      )
    end

    def translated_resource
      t("activerecord.models.#{resource_class.model_name.i18n_key}", count: SINGULAR_COUNT)
    end
  end
end
