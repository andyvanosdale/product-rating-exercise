# frozen_string_literal: true

class Review::CreatedJob < BaseWorker
  def initialize
    @product_ranker = ProductRanker.new
  end

  def perform(review_id, product_id)
    product = Product.find(product_id)
    rank_product(product)
  end

  private

  def rank_product(product)
    @product_ranker.rank(product)
  end
end
