# == Schema Information
#
# Table name: products
#
#  id          :uuid             not null, primary key
#  description :string
#  name        :string           not null
#  rank        :float            default(0.0)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_products_on_name                       (name) UNIQUE
#  index_products_on_rank_desc_created_at_desc  (rank,created_at)
#
require 'rails_helper'

RSpec.describe Product, type: :model do
  describe "when creating" do
    it "does not require description" do
      product = Product.create(name: "Test Name")
      product.save

      expect(product.valid?).to be(true)
    end
  end

  describe "when destroying" do
    it "destroys dependent reviews" do
      product = FactoryBot.create(:product)
      review = FactoryBot.create(:review, product: product)
      product.destroy
      expect{ Review.find(review.id) }.to raise_exception(ActiveRecord::RecordNotFound)
    end
  end
end
