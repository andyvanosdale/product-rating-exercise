require 'rails_helper'
RSpec.describe Review::CreatedJob, type: :job do
  subject { Review::CreatedJob.new }

  describe "#perform" do
    let(:product) { FactoryBot.create(:product) }
    let(:review) { FactoryBot.create(:review, rating: 1, product: product) }
    before { subject.perform(review.id, product.id) }

    it "ranks product" do
      expect(product.reload.rank).to be > 0.0
    end
  end
end
