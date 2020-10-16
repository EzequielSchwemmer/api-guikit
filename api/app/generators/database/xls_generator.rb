module Database
  class XlsGenerator
    # A big number is used instead of 2, because there are some languajes than has
    # a plural for zero, one, two, etc.
    FORCE_PLURALIZED_COUNT = 1000
    EMPTY_CELL = '   '.freeze
    LOCALIZED_TYPES = [Date, Time, DateTime].freeze

    attr_reader :options

    def export(selected_params, options = {})
      @options = options
      selected_models = finder.select_models(selected_params)
      export_models(selected_models)
      package
    end

    def all_selected
      model_keys.each_with_object({}) do |key, hash|
        hash[key] = true
      end
    end

    delegate :application_models, :model_keys, to: :finder

    private

    delegate :workbook, to: :package

    # Warning: This operation is time consuming
    def export_models(models)
      relations_for(models).each(&method(:add_to_package))
    end

    def add_to_package(relation)
      human_name = relation.humanize_name
      workbook.add_worksheet(name: human_name) do |sheet|
        cell_count = relation.xls_columns.size + style_for(sheet).spacing_columns * 2
        add_spacing_rows(sheet, cell_count)
        add_header(relation, sheet)
        add_rows(relation, sheet)
        add_spacing_rows(sheet, cell_count)
      end
    end

    def add_spacing_rows(sheet, cell_count)
      style = style_for(sheet)
      style.spacing_rows.times do
        empty_row = Array.new(cell_count) { |_| EMPTY_CELL }
        sheet.add_row(empty_row, style: style.empty_style)
      end
    end

    def add_header(relation, sheet)
      row = sheet.add_row
      add_spacing_cells(sheet, row)
      add_header_cells(sheet, row, relation)
      add_spacing_cells(sheet, row)
    end

    def add_header_cells(sheet, row, relation)
      style = style_for(sheet).header_style
      relation.human_column_names.each do |name|
        cell = row.add_cell(name)
        cell.style = style
      end
    end

    def add_rows(relation, sheet)
      relation.find_each(batch_size: 50) do |element|
        row = sheet.add_row
        add_spacing_cells(sheet, row)
        add_values(sheet, row, element)
        add_spacing_cells(sheet, row)
      end
    end

    def add_spacing_cells(sheet, row)
      style = style_for(sheet)
      style.spacing_columns.times do
        cell = row.add_cell(EMPTY_CELL)
        cell.style = style.empty_style
      end
    end

    def add_values(sheet, row, element)
      style = style_for(sheet).row_style
      element.xls_attributes.each do |attribute|
        cell = row.add_cell(localize(attribute), type: :string)
        cell.style = style
      end
    end

    def package
      @package ||= Axlsx::Package.new
    end

    def finder
      @finder ||= ModelFinder.new
    end

    def localize(value)
      return value unless LOCALIZED_TYPES.any? { |type| value.is_a?(type) }

      I18n.l(value)
    end

    # Styles are shared on the same sheet, but not on the same file in XLS
    def style_for(sheet)
      @styles ||= {}
      @styles[sheet] ||= Database::XlsGenerator::Styles.new(sheet, options)
    end

    def relations_for(models)
      models.map { |model| relation_for(model) }
    end

    def relation_for(model)
      Database::XlsGenerator::Relation.new(model, options)
    end
  end
end
