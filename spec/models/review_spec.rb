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
require 'rails_helper'

RSpec.describe Review, type: :model do
  describe "when creating" do
    it "does not require body" do
      product = FactoryBot.create(:product)
      rating = Review.create(author: "Test Author", headline: "Test Headline", rating: 5, product: product)
      rating.save

      expect(rating.valid?).to be(true)
    end

    describe "when validating" do
      describe "rating" do
        it "must be greater than or equal to 1" do
          product = FactoryBot.create(:product)
          rating = Review.create(author: "Test Author", headline: "Test Headline", rating: 0, product: product)
          rating.save

          expect(rating.valid?).to be(false)
          expect(rating.errors.of_kind?(:rating, :greater_than_or_equal_to)).to be(true)
        end
        it "must be less than or equal to 5" do
          product = FactoryBot.create(:product)
          rating = Review.create(author: "Test Author", headline: "Test Headline", rating: 6, product: product)
          rating.save

          expect(rating.valid?).to be(false)
          expect(rating.errors.of_kind?(:rating, :less_than_or_equal_to)).to be(true)
        end
      end
    end
  end
end
