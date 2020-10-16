module Administrate
  module Field
    class NiceHasOne < HasOne
      def nested_show
        @nested_show ||= Administrate::Page::Show.new(
          resolver.dashboard_class.new,
          data || resolver.resource_class.new
        )
      end
    end
  end
end
