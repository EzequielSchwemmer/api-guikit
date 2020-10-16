class RandomDiscounts
  include Interactor

  def call
    context.discounts = Discount.running.featured.order(Arel.sql('random()')).limit(12)
  end
end
