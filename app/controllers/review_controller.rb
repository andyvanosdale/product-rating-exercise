# frozen_string_literal: true

class ReviewController < ApplicationController
  before_action :require_product
  before_action :validate_sort_params, only: [:index]

  def create
    @review = Review.create(create_params)
    @review.product = @product

    if @review.save
      render json: @review, status: :created
    else
      render json: @review.errors, status: :unprocessable_entity
    end
  end

  ##
  # Returns the reviews for a given product
  #
  # Sorting is available via the following parameters:
  # +sort_by+: +rating+ for rating, +created_at+ for created timestamp
  # +sort_order+: +asc+ for ascending, +desc+ for descending; +sort_order+ will only be
  # provided if +sort_by+ is specified.
  # A default and lowest level sort of +created_at+ +desc+ is automatically applied.
  def index
    @reviews = Review
      .where(product_id: @product.id)
      .order("#{params[:sort_by] || :created_at} #{params[:sort_order] || :desc}, created_at desc")

    # Secondary sort in case there are ties with the primary sort (i.e.: same rating)
    if params[:sort_by] != :created_at
      @reviews.order("created_at desc")
    end

    render json: @reviews, status: :ok
  end

  private

  def require_product
    @product = Product.find(params[:product_id])
  end

  def create_params
    params.require(:review).permit(:author, :rating, :headline, :body)
  end

  def validate_sort_params
    return if !params[:sort_by].present?

    errors = {}

    if !["created_at", "rating"].include?(params["sort_by"])
      (errors[:sort_by] ||= []).push("must be created_at or rating")
    end

    if params["sort_order"].present? && !["asc", "desc"].include?(params["sort_order"])
      (errors[:sort_order] ||= []).push("must be asc or desc")
    end

    if !errors.empty?
      render json: errors, status: :unprocessable_entity
    end
  end
end
