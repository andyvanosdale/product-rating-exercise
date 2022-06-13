require 'rails_helper'

RSpec.describe "Reviews", type: :request do
  context "with valid product" do
    author = "Test Author"
    rating = 5
    headline = "Test Headline"

    product = FactoryBot.create(:product)

    describe "POST /" do
      it "creates" do
        post "/product/#{product.id}/review", params: { review: { author: author, rating: rating, headline: headline }}

        expect(response).to have_http_status(:created)
        expect(response.body).to_not be_nil
        response_body = JSON.parse(response.body)
        expect(response_body["id"]).to_not be_nil
        expect(response_body["author"]).to eq(author)
        expect(response_body["rating"]).to eq(rating)
        expect(response_body["headline"]).to eq(headline)
        expect(response_body["body"]).to be_nil
        expect(response_body["created_at"]).to_not be_nil
        expect(response_body["updated_at"]).to_not be_nil
      end

      context "with rating below minimum" do
        bad_rating = 0

        it "returns error" do
          post "/product/#{product.id}/review", params: { review: { author: author, rating: bad_rating, headline: headline }}

          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to_not be_nil
          response_body = JSON.parse(response.body)
          expect(response_body["rating"]).to_not be_nil
          expect(response_body["rating"][0]).to eq("must be greater than or equal to 1")
        end
      end
      context "with rating above maximum" do
        bad_rating = 6

        it "returns error" do
          post "/product/#{product.id}/review", params: { review: { author: author, rating: bad_rating, headline: headline }}

          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to_not be_nil
          response_body = JSON.parse(response.body)
          expect(response_body["rating"]).to_not be_nil
          expect(response_body["rating"][0]).to eq("must be less than or equal to 5")
        end
      end

      context "with body" do
        body = "Test body"

        it "creates" do
          post "/product/#{product.id}/review", params: { review: { author: author, rating: rating, headline: headline, body: body }}

          expect(response).to have_http_status(:created)
          expect(response.body).to_not be_nil
          response_body = JSON.parse(response.body)
          expect(response_body["body"]).to eq(body)
        end
      end
    end
  end
end
