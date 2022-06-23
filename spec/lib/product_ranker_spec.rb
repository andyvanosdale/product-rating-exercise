RSpec.describe ProductRanker do
  let(:product_ranker) { ProductRanker.new }

  describe "#rank" do
    let!(:product) { FactoryBot.create(:product) }
    after { product.destroy }

    context "with no reviews" do
      before { rank() }

      it "is ranked correctly" do
        expect(product.rank).to eq(0.0)
      end
    end

    context "with a 1 star review" do
      before { FactoryBot.create(:review, rating: 1, product: product) }
      before { rank() }

      it "is ranked correctly" do
        expect(product.rank).to eq(0.2)
      end
    end

    context "with a 5 star review" do
      before { FactoryBot.create(:review, rating: 5, product: product) }
      before { rank() }

      it "is ranked correctly" do
        expect(product.rank).to eq(1.0)
      end

      context "with a 1 star review" do
        before { FactoryBot.create(:review, rating: 1, product: product) }
        before { rank() }

        it "ranks" do
          expect(product.rank).to eq(0.6)
        end
      end
      context "with a 5 star review" do
        before { FactoryBot.create(:review, rating: 5, product: product) }
        before { rank() }

        it "ranks" do
          expect(product.rank).to eq(1.0)
        end
      end
    end
  end
end

def rank
  product_ranker.rank(product)
  product.reload
end
