module Database
  class XlsGenerator
    class Styles
      SPACING_ROWS = Rails.application.secrets.xls_spacing_rows
      SPACING_COLUMNS = Rails.application.secrets.xls_spacing_columns

      attr_reader :sheet, :options

      def initialize(sheet, options)
        @sheet = sheet
        @options = options
      end

      def header_style
        @header_style ||= sheet.styles.add_style(
          b: true,
          border: header_border_style,
          bg_color: Rails.application.secrets.xls_header_bg_color,
          fg_color: Rails.application.secrets.xls_header_fg_color
        )
      end

      def row_style
        @row_style ||= sheet.styles.add_style(
          bg_color: Rails.application.secrets.xls_row_bg_color,
          fg_color: Rails.application.secrets.xls_row_fg_color,
          border: row_border_style
        )
      end

      def empty_style
        @empty_style ||= sheet.styles.add_style(
          bg_color: Rails.application.secrets.xls_empty_bg_color,
          border: false
        )
      end

      def spacing_rows
        @spacing_rows ||= options[:spacing_rows].presence&.to_i || SPACING_ROWS
      end

      def spacing_columns
        @spacing_columns ||= options[:spacing_columns].presence&.to_i || SPACING_COLUMNS
      end

      private

      def header_border_style
        @header_border_style ||= {
          style: :thin,
          color: Rails.application.secrets.header_border_color,
          edges: %i[top bottom]
        }
      end

      def row_border_style
        @row_border_style ||= {
          style: :thin,
          color: Rails.application.secrets.row_border_color,
          edges: %i[bottom]
        }
      end
    end
  end
end
