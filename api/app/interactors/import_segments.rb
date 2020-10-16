class ImportSegments
  include Interactor

  def call
    find_segments
    import_segments
  end

  private

  def find_segments
    segment_names = context.json.values.flatten.uniq
    @segments = Segment.where(name: segment_names)
    @segments_to_import = segment_names - @segments.pluck(:name)
  end

  def import_segments
    Segment.import(@segments_to_import.map { |name| { name: name } })
    context.segments_imported = @segments_to_import
    context.segment_ids = @segments.ids
  end
end
