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

RSpec::Matchers.define :reloadable_value do |reloadable, method|
  match do |actual|
    reloadable.reload
    actual == reloadable.public_send(method)
  end
end

RSpec.describe Review, type: :model do
  let(:product) { FactoryBot.create(:product) }
  after { product.destroy! }

  describe "when creating" do
    describe "does not have a body" do
      let(:rating) { FactoryBot.create(:review, body: nil, product: product) }

      it "is valid" do
        expect(rating.valid?).to be(true)
      end
    end

    describe "when validating" do
      describe "rating" do
        describe "must be greater than or equal to 1" do
          let(:rating) { FactoryBot.build(:review, rating: 0, product: product) }

          it "raises error" do
            expect{ rating.save! }.to raise_error(ActiveRecord::RecordInvalid)
          end
          it "has rating error" do
            rating.save
            expect(rating.errors.of_kind?(:rating, :greater_than_or_equal_to)).to be(true)
          end
        end

        describe "must be less than or equal to 5" do
          let(:rating) { FactoryBot.build(:review, rating: 6, product: product) }

          it "raises exception" do
            expect{ rating.save! }.to raise_exception(ActiveRecord::RecordInvalid)
          end
          it "has rating error" do
            rating.save
            expect(rating.errors.of_kind?(:rating, :less_than_or_equal_to)).to be(true)
          end
        end
      end
    end

    describe "after_create" do
      let(:rating) { FactoryBot.build(:review, product: product) }

      it "ranks product" do
        expect(Review::CreatedJob).to receive(:perform_async).with(reloadable_value(rating, :id), product.id)
        rating.save!
      end
    end
  end
end
