module Administrate
  module Field
    class ReadableBoolean < Boolean
      def to_s
        I18n.t("activerecord.boolean.#{data.present?}")
      end
    end
  end
end
