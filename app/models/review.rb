# frozen_string_literal: true

# == Schema Information
#
# Table name: reviews
#
#  id         :uuid             not null, primary key
#  author     :string           not null
#  body       :string
#  headline   :string           not null
#  rating     :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  product_id :uuid             not null
#
# Indexes
#
#  index_reviews_on_product_id                      (product_id)
#  index_reviews_on_product_id_and_created_at_asc   (product_id,created_at)
#  index_reviews_on_product_id_and_created_at_desc  (product_id,created_at DESC)
#  index_reviews_on_product_id_and_rating_asc       (product_id,rating)
#  index_reviews_on_product_id_and_rating_desc      (product_id,rating DESC)
#

class Review < ApplicationRecord
  belongs_to :product

  validates :rating, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }

  after_create :notify_created

  private

  def notify_created
    Review::CreatedJob.perform_async(id, product_id)
  end
end
