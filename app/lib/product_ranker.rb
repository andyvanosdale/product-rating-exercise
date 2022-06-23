class ProductRanker
  ##
  # Ranks a product based upon their reviews
  #
  # Sum the ratings and divides by the total possible value
  # For instance, a product with 2 reviews with 2 and 4 star reviews would be 6/10
  def rank(product)
    local_product = Product.find(product.id)

    count = local_product.reviews.count || 0
    product_rank = 0.0
    sum = 0

    if count > 0
      sum = local_product.reviews.map(&:rating).reduce(:+)
      product_rank = sum.to_f / (count * 5)
    end
    local_product.rank = product_rank
    local_product.save!
    Rails.logger.info("product=#{local_product.id} rank=#{local_product.rank} sum=#{sum} count=#{count}")
  end
end
