require 'rails_helper'

RSpec.describe "Reviews", type: :request do
  context "with valid product" do
    author = "Test Author"
    rating = 5
    headline = "Test Headline"

    before do
      @product = FactoryBot.create(:product)
    end
    after do
      @product.destroy
    end

    describe "POST /" do
      it "creates" do
        post "/product/#{@product.id}/review", params: { review: { author: author, rating: rating, headline: headline }}

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
          post "/product/#{@product.id}/review", params: { review: { author: author, rating: bad_rating, headline: headline }}

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
          post "/product/#{@product.id}/review", params: { review: { author: author, rating: bad_rating, headline: headline }}

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
          post "/product/#{@product.id}/review", params: { review: { author: author, rating: rating, headline: headline, body: body }}

          expect(response).to have_http_status(:created)
          expect(response.body).to_not be_nil
          response_body = JSON.parse(response.body)
          expect(response_body["body"]).to eq(body)
        end
      end
    end

    describe "GET /" do
      context "if there are no reviews for a product" do
        it "returns no reviews" do
          get "/product/#{@product.id}/review"

          expect(response).to have_http_status(:success)
          expect(response.body).to_not be_nil
          response_body = JSON.parse(response.body)
          expect(response_body).to be_an_instance_of(Array)
          expect(response_body.length).to eq(0)
        end
      end

      context "if there are reviews for a product" do
        before do
          @reviews = []
          @reviews.push(FactoryBot.create(:review, product: @product, rating: 3))
          @reviews.push(FactoryBot.create(:review, product: @product, rating: 1))
          @reviews.push(FactoryBot.create(:review, product: @product, rating: 1))
          @reviews.push(FactoryBot.create(:review, product: @product, rating: 5))
          @reviews.push(FactoryBot.create(:review, product: @product, rating: 4))
        end

        it "returns all reviews" do
          get "/product/#{@product.id}/review"

          expect(response).to have_http_status(:success)
          expect(response.body).to_not be_nil
          response_body = JSON.parse(response.body)
          expect(response_body).to be_an_instance_of(Array)
          # Default order is descending by created time
          expect(response_body[0]["id"]).to eq(@reviews[4].id)
          expect(response_body[1]["id"]).to eq(@reviews[3].id)
          expect(response_body[2]["id"]).to eq(@reviews[2].id)
          expect(response_body[3]["id"]).to eq(@reviews[1].id)
          expect(response_body[4]["id"]).to eq(@reviews[0].id)
        end

        context "sort by rating" do
          context "default (descending)" do
            it "sorts" do
              get "/product/#{@product.id}/review?sort_by=rating"

              expect(response).to have_http_status(:success)
              expect(response.body).to_not be_nil
              response_body = JSON.parse(response.body)
              expect(response_body).to be_an_instance_of(Array)
              expect(response_body[0]["id"]).to eq(@reviews[3].id)
              expect(response_body[1]["id"]).to eq(@reviews[4].id)
              expect(response_body[2]["id"]).to eq(@reviews[0].id)
              # Default sort after same ratings is created_at desc
              expect(response_body[3]["id"]).to eq(@reviews[2].id)
              expect(response_body[4]["id"]).to eq(@reviews[1].id)
            end
          end

          context "ascending" do
            it "sorts" do
              get "/product/#{@product.id}/review?sort_by=rating&sort_order=asc"

              expect(response).to have_http_status(:success)
              expect(response.body).to_not be_nil
              response_body = JSON.parse(response.body)
              expect(response_body).to be_an_instance_of(Array)
              # Default sort after same ratings is created_at desc
              expect(response_body[0]["id"]).to eq(@reviews[2].id)
              expect(response_body[1]["id"]).to eq(@reviews[1].id)
              expect(response_body[2]["id"]).to eq(@reviews[0].id)
              expect(response_body[3]["id"]).to eq(@reviews[4].id)
              expect(response_body[4]["id"]).to eq(@reviews[3].id)
            end
          end
        end
        context "sort by created_at" do
          context "ascending" do
            it "sorts" do
              get "/product/#{@product.id}/review?sort_by=created_at&sort_order=asc"

              expect(response).to have_http_status(:success)
              expect(response.body).to_not be_nil
              response_body = JSON.parse(response.body)
              expect(response_body).to be_an_instance_of(Array)
              expect(response_body[0]["id"]).to eq(@reviews[0].id)
              expect(response_body[1]["id"]).to eq(@reviews[1].id)
              expect(response_body[2]["id"]).to eq(@reviews[2].id)
              expect(response_body[3]["id"]).to eq(@reviews[3].id)
              expect(response_body[4]["id"]).to eq(@reviews[4].id)
            end
          end
        end
        context "invalid sorts" do
          context "sort_by" do
            it "fails" do
              get "/product/#{@product.id}/review?sort_by=updated_at"

              expect(response).to have_http_status(:unprocessable_entity)
              expect(response.body).to_not be_nil
              response_body = JSON.parse(response.body)
              expect(response_body).to be_an_instance_of(Hash)
              expect(response_body["sort_by"][0]).to eq("must be created_at or rating")
            end
          end
          context "sort_order" do
            it "fails" do
              get "/product/#{@product.id}/review?sort_by=rating&sort_order=ordered"

              expect(response).to have_http_status(:unprocessable_entity)
              expect(response.body).to_not be_nil
              response_body = JSON.parse(response.body)
              expect(response_body).to be_an_instance_of(Hash)
              expect(response_body["sort_order"][0]).to eq("must be asc or desc")
            end
          end
        end
      end
    end
  end
end
