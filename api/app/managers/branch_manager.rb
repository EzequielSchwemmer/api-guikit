class BranchManager < ApplicationManager
  attr_reader :retailer

  def initialize(retailer, params)
    super(params)
    @retailer = retailer
  end

  def create
    Branch.find_or_create_by(retailer: retailer, name: name)
  end

  private

  def name
    @name ||= normalize_text(params[:name], collection: Branch)
  end
end
