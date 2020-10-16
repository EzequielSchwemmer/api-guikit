module FakeModels
  class Database < Base
    class <<self
      def model_name
        @model_name ||= ActiveModel::Name.new(self, nil, 'Export')
      end

      def finder
        @finder ||= ModelFinder.new
      end
    end

    attr_accessor :options
    # Find all model keys and make them accessors
    attr_accessor(*finder.model_keys)

    validates :options, validity: true
    delegate :model_keys, to: :finder
    delegate :finder, to: :class
  end
end
