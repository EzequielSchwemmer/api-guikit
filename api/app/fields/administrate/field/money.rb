module Administrate
  module Field
    class Money < Base
      delegate :format, to: :data, allow_nil: true
    end
  end
end
