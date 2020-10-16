module Concerns
  module FastJsonSerializable
    extend ActiveSupport::Concern

    # Override to_json to use fast_jsonapi as regular serializers
    def to_json(options = {}, *args)
      return options[:serializer].new(self, options, *args).serialized_json if options[:serializer]

      super
    end
  end
end
