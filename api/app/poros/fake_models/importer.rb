module FakeModels
  class Importer < Base
    class <<self
      def model_name
        @model_name ||= ActiveModel::Name.new(self, nil, 'Importer')
      end
    end

    attr_accessor :file
  end
end
