class RetailerManager < ApplicationManager
  def initialize(params)
    super(params)
  end

  def create
    Retailer.find_or_create_by(name: name)
  end

  private

  def name
    @name ||= normalize_text(params[:name], collection: Retailer)
  end
end
