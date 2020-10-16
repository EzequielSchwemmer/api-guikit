module RenderNested
  extend ActiveSupport::Concern

  def render_with_relation(records_collection, related_models: [], serializer: nil)
    options = { include: related_models }
    render json: serialize(serializer, records_collection, options)
  end

  private

  def serialize(serializer, collection, options)
    if serializer.nil?
      collection
    else
      serializer.new(collection, options).serialized_json
    end
  end
end
