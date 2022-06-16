class AddSortIndexesToReviews < ActiveRecord::Migration[6.1]
  def change
    add_index :reviews, [:product_id, :rating], name: "index_reviews_on_product_id_and_rating_asc", order: { rating: :asc }
    add_index :reviews, [:product_id, :rating], name: "index_reviews_on_product_id_and_rating_desc", order: { rating: :desc }
    add_index :reviews, [:product_id, :created_at], name: "index_reviews_on_product_id_and_created_at_asc", order: { created_at: :asc }
    add_index :reviews, [:product_id, :created_at], name: "index_reviews_on_product_id_and_created_at_desc", order: { created_at: :desc }
  end
end
