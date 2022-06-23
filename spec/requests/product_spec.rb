require 'rails_helper'

RSpec.describe "Product", type: :request do
  describe "GET /:id" do
    describe "with invalid product ID", :realistic_error_responses do
      before { get "/product/123456" }

      it "returns error" do
        expect(response).to have_http_status(:not_found)
      end
    end

    context "with product" do
      let(:product) { FactoryBot.create(:product) }
      after { product.destroy! }

      describe "with valid product ID" do
        before { get "/product/#{product.id}" }

        it "is successful" do
          expect(response).to have_http_status(:success)
        end
        it "has a response body" do
          expect(response.body).to_not be_nil
        end

        context "with parsed response body" do
          let(:response_body) { JSON.parse(response.body) }

          it "matches the id" do
            expect(response_body["id"]).to eq(product.id)
          end
          it "matches the name" do
            expect(response_body["name"]).to eq(product.name)
          end
          it "matches the description" do
            expect(response_body["description"]).to eq(product.description)
          end
          it "matches the created_at" do
            expect(response_body["created_at"]).to eq(product.created_at.strftime('%Y-%m-%dT%H:%M:%S.%LZ'))
          end
          it "matches the updated_at" do
            expect(response_body["updated_at"]).to eq(product.updated_at.strftime('%Y-%m-%dT%H:%M:%S.%LZ'))
          end
        end
      end
    end

    context "with multiple products" do
      let(:products) { (0..2).map{ |x| FactoryBot.create(:product) } }
      after { products.each(&:destroy) }

      context "with ranks" do
        let(:ranks) { [0.2, 1, 0.2] }
        before(:each) do
          ranks.each_with_index do |rank, index|
            product = products[index]
            product.rank = rank
            product.save!
          end
        end

        describe "orders by ranks" do
          before { get "/product" }

          it "is successful" do
            expect(response).to have_http_status(:success)
          end
          it "has a response body" do
            expect(response.body).to_not be_nil
          end

          context "with parsed response body" do
            let(:response_body) { JSON.parse(response.body) }

            it "is an array" do
              expect(response_body).to be_an_instance_of(Array)
            end
            it "has the correct product in the 0 index" do
              expect(response_body[0]["id"]).to eq(products[1].id)
            end
            it "has the correct product in the 1 index" do
              expect(response_body[1]["id"]).to eq(products[2].id)
            end
            it "has the correct product in the 2 index" do
              expect(response_body[2]["id"]).to eq(products[0].id)
            end
          end
        end
      end
    end
  end
end
