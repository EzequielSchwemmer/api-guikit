module Database
  class XlsGenerator
    class Relation
      # There is a limit on how long an XLS sheet name is
      SHEET_NAME_MAX_SIZE = 31
      QUERY_STEPS = %i[add_since_to add_upto_to add_limit_to add_offset_to].freeze

      attr_reader :model, :options

      delegate :columns, :xls_columns, to: :model
      delegate :find_each, to: :resolve
      delegate :since, :limit, :offset, :upto, to: :options

      def initialize(model, options)
        @model = model.unscoped
        @options = OpenStruct.new(transform_options(options))
      end

      def resolve
        @resolve ||= query_steps.reduce(model) { |query, step| step.call(query) }
      end

      def humanize_name
        name = model.model_name.human(count: FORCE_PLURALIZED_COUNT)
        # Sheet column names cannot be more than 31 characters long
        return name if name.size <= SHEET_NAME_MAX_SIZE

        "#{name[0...(SHEET_NAME_MAX_SIZE - 3)]}..."
      end

      def human_column_names
        model.xls_columns.map do |column|
          model.human_attribute_name(column)
        end
      end

      private

      def query_steps
        QUERY_STEPS.map(&method(:method))
      end

      def add_since_to(query)
        since.present? ? query.since(since) : query
      end

      def add_upto_to(query)
        upto.present? ? query.upto(upto) : query
      end

      def add_limit_to(query)
        limit.present? && limit.positive? ? query.limit(limit) : query
      end

      def add_offset_to(query)
        offset.present? && offset.positive? ? query.offset(offset) : query
      end

      def transform_options(options)
        options.slice(:since, :upto).merge(
          offset: options[:offset]&.to_i,
          limit: options[:limit]&.to_i
        )
      end
    end
  end
end
