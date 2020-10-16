module Administrate
  module Field
    class Multiselect < Base
      def selection
        model.all.order(:id)
      end

      def format
        options[:format] || :id
      end

      private

      def model
        @model ||= options[:model].presence || options[:model_name].classify.constantize
      end
    end
  end
end
