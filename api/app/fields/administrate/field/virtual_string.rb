module Administrate
  module Field
    class VirtualString < String
      def self.searchable?
        false
      end
    end
  end
end
