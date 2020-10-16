module Administrate
  module Field
    class EnumSelect < Administrate::Field::Select
      def selectable_options
        @selectable_options ||=
          enum.each_key.map do |name|
            OpenStruct.new(value: name, text: I18n.t(translation_key_for(name)))
          end
      end

      def to_s
        I18n.t(translation_key_for(data))
      end

      private

      def enum
        @enum ||= model.public_send(enum_name)
      end

      def enum_name
        @enum_name ||= options[:enum]
      end

      def model
        @model ||= options.fetch(:model) { resource.class }
      end

      def translation_key_for(name)
        "activerecord.enums.#{model.model_name.i18n_key}.#{enum_name}.#{name}"
      end
    end
  end
end
