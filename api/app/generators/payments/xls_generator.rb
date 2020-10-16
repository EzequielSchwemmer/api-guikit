module Payments
  class XlsGenerator
    Styles = ::Database::XlsGenerator::Styles

    EMPTY_CELL = ::Database::XlsGenerator::EMPTY_CELL
    FORCE_PLURALIZED_COUNT = ::Database::XlsGenerator::FORCE_PLURALIZED_COUNT
    EXPORT_ATTRIBUTES = %i[
      user_id
      user_name
      user_last_name
      user_email
      bank_name
      cbu
      bank_alias
      cuit
      total_refund
    ].freeze

    attr_accessor :options

    def export(pending_payments, options = {})
      self.options = options
      pending_payments.each do |payment|
        add_spacing_rows
        add_header
        add_payment_row(payment)
        add_spacing_rows
      end
      package
    end

    private

    delegate :workbook, to: :package

    def add_spacing_rows
      cell_count = styles.spacing_columns * 2 + EXPORT_ATTRIBUTES.size
      styles.spacing_rows.times do
        empty_row = Array.new(cell_count) { |_| EMPTY_CELL }
        sheet.add_row(empty_row, style: styles.empty_style)
      end
    end

    def add_header
      row = sheet.add_row
      add_spacing_columns(row)
      header_row.each do |text|
        cell = row.add_cell(text)
        cell.style = styles.header_style
      end
      add_spacing_columns(row)
    end

    def add_payment_row(payment)
      row = sheet.add_row
      add_spacing_columns(row)
      row_attributes_for(payment).each do |attribute|
        cell = row.add_cell(attribute, type: :string)
        cell.style = styles.row_style
      end
      add_spacing_columns(row)
    end

    def add_spacing_columns(row)
      styles.spacing_columns.times do
        cell = row.add_cell(EMPTY_CELL)
        cell.style = styles.empty_style
      end
    end

    def header_row
      EXPORT_ATTRIBUTES
        .map(&method(:build_attribute_key))
        .map(&I18n.method(:t))
    end

    def build_attribute_key(base)
      "activerecord.attributes.pending_payment.#{base}"
    end

    def row_attributes_for(payment)
      [
        payment.user_id, payment.user_name,
        payment.user_last_name,
        payment.user_email,
        payment.bank_name,
        payment.cbu,
        payment.bank_alias,
        payment.cuit,
        payment.total_refund.format
      ]
    end

    def package
      @package ||= Axlsx::Package.new
    end

    def sheet
      @sheet ||= workbook.add_worksheet(name: sheet_name)
    end

    def styles
      @styles ||= Styles.new(sheet, options)
    end

    def sheet_name
      I18n.t('activerecord.models.pending_payment', count: FORCE_PLURALIZED_COUNT)
    end
  end
end
