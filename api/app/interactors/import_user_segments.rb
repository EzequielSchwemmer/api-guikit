class ImportUserSegments
  include Interactor

  def call
    process_file
    import
  end

  private

  def process_file
    segments = Segment.where(id: context.segment_ids).pluck(:name, :id).to_h
    context.json.each do |user_id, segment_names|
      context.json[user_id] = { segment_ids: segments.slice(*segment_names).values }
    end
  end

  def import
    User.update(context.json.keys, context.json.values)
  end
end
