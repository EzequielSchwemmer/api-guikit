module Admin
  module ApplicationHelper
    PLACEHOLDER_URL = Rails.application.secrets.placeholder_url.freeze

    def navbar_link_to(path, &block)
      classes = "sidebar__link sidebar__link--#{current_page?(path) ? 'active' : 'inactive'}"
      link_to(path, class: classes, &block)
    end

    def resource_icon_for(resource)
      dashboard_for(resource).resource_icon
    end

    def dashboard_for(resource)
      @dashboards ||= {}
      @dashboards[resource.name] ||= "#{resource.to_s.classify}Dashboard".constantize.new
    end

    def attachment_url_for(attachment, **kwargs)
      attachment.attached? ? url_for(attachment) : placeholder_url(**kwargs)
    end

    def placeholder_url(width: 640, height: width, foreground: '333333', background: 'CCCCCC')
      "#{PLACEHOLDER_URL}/#{width}x#{height}/#{background}/#{foreground}.png"
    end

    def available_segments
      @available_segments ||= Segment.all
    end

    def format_discount(discount)
      "#{discount.discount_type} #{discount.title} #{discount.description}"
    end

    def in_sidebar?(resource)
      return false if resource.blank?

      policy_for(class_from_resource(resource))&.index?
    # This case applies for example, to, for example push notifications because they are
    # in the router but they don't have a model attached.
    rescue StandardError
      false
    end

    def policy_for(resource)
      Pundit.policy(pundit_user, resource)
    end
  end
end
