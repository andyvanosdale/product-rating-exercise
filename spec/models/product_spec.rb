# == Schema Information
#
# Table name: products
#
#  id          :uuid             not null, primary key
#  description :string
#  name        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_products_on_name  (name) UNIQUE
#
require 'rails_helper'

RSpec.describe Product, type: :model do
  describe "when creating" do
    it "does not require description" do
      product = Product.create(name: "Test Name")
      product.save

      expect(product.valid?).to be true
    end
  end
end
