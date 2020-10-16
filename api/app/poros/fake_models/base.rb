module FakeModels
  class Base
    include ActiveModel::Model

    def persisted?
      false
    end
  end
end
