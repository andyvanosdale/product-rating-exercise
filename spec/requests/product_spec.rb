require 'rails_helper'

RSpec.describe "Product", type: :request do
  context "with product" do
    product = FactoryBot.create(:product)

    describe "GET /:id" do
      it "returns product" do
        get "/product/#{product.id}"

        expect(response).to have_http_status(:success)
        expect(response.body).to_not be_nil
        response_body = JSON.parse(response.body)
        expect(response_body["id"]).to eq(product.id)
        expect(response_body["name"]).to eq(product.name)
        expect(response_body["description"]).to eq(product.description)
        expect(response_body["created_at"]).to eq(product.created_at.strftime('%Y-%m-%dT%H:%M:%S.%LZ'))
        expect(response_body["updated_at"]).to eq(product.updated_at.strftime('%Y-%m-%dT%H:%M:%S.%LZ'))
      end
    end
  end
end
