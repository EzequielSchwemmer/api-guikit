module Faker
  module Ean13
    class << self
      def valid
        Faker::Code.ean
      end

      def invalid
        readlines('invalid.txt').sample
      end

      private

      def readlines(name)
        lines = ::File.readlines(Rails.root.join('spec', 'support', 'fixtures', 'ean13', name))
        lines.select(&:present?).map(&:strip)
      end
    end
  end
end
