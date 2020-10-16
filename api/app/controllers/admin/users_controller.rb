module Admin
  class UsersController < Admin::ApplicationController
    # To customize the behavior of this controller,
    # you can overwrite any of the RESTful actions. For example:
    #
    # def index
    #   super
    #   @resources = User.
    #     page(params[:page]).
    #     per(10)
    # end

    # Define a custom finder by overriding the `find_resource` method:
    # def find_resource(param)
    #   User.find_by!(slug: param)
    # end

    # See https://administrate-prototype.herokuapp.com/customizing_controller_actions
    # for more information

    def create
      resource = resource_class.new(resource_params)
      authorize_resource(resource)

      if resource.save
        set_user_info(resource, user_params_segments)
        redirect_to_page(namespace, resource, translate_with_resource('create.success'))
      else
        render_resource_page(:new, resource)
      end
    end

    def update
      if requested_resource.update(resource_params)
        set_user_info(requested_resource, user_params_segments)
        redirect_to_page(namespace, requested_resource, translate_with_resource('update.success'))
      else
        render_resource_page(:edit, requested_resource)
      end
    end

    private

    def set_user_info(user, segments)
      SetUserDiscounts.call(user: user)
      SetUserSnsTopics.call(
        user: user,
        segments: segments
      )
    end

    def user_params_segments
      return [] if resource_params['segment_ids'].nil?

      resource_params['segment_ids'].map do |segment_id|
        Segment.find_by(id: segment_id.to_i)
      end.compact
    end

    def redirect_to_page(namespace, resource, notice)
      redirect_to(
        [namespace, resource],
        notice: notice
      )
    end

    def render_resource_page(action, resource)
      render action, locals: {
        page: Administrate::Page::Form.new(dashboard, resource)
      }
    end
  end
end
