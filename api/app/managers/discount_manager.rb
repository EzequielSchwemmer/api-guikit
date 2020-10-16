class DiscountManager < ApplicationManager
  attr_reader :current_user

  def initialize(current_user, params)
    super(params)
    @current_user = current_user
  end

  def create
    discount = Discount.new(direct_params)
    Discount.transaction do
      discount.save
      discount.segments = find_segments
      discount.save!
    rescue StandardError
      raise ActiveRecord::Rollback
    end
    discount
  end

  def update(discount)
    result = false
    Discount.transaction do
      discount.assign_attributes(direct_params)
      discount.segments = find_segments
      result = discount.save
    rescue StandardError
      raise ActiveRecord::Rollback
    end
    result
  end

  private

  def direct_params
    params.slice(
      :discount_type, :title, :description, :product_description, :cost,
      :starts_at, :ends_at, :active, :featured, :steps_attributes,
      :terms_and_conditions, :picture
    )
  end

  def find_segments
    # Using where because segment_params could be an id or an array
    Segment.where(id: segment_params)
  end

  def segment_params
    params[:segment_ids]
  end
end
