class SegmentManager < ApplicationManager
  def create
    Segment.find_or_create_by(name: name)
  end

  private

  def name
    @name ||= normalize_text(params[:name], collection: Segment)
  end
end
