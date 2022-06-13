# frozen_string_literal: true

class ReviewController < ApplicationController
  before_action :require_product

  def create
    @review = Review.create(create_params)
    @review.product = @product

    if @review.save
      render json: @review, status: :created
    else
      render json: @review.errors, status: :unprocessable_entity
    end
  end

  private

  def require_product
    @product = Product.find(params[:product_id])
  end

  def create_params
    params.require(:review).permit(:author, :rating, :headline, :body)
  end
end
