# frozen_string_literal: true

class CreateReviews < ActiveRecord::Migration[6.1]
  def change
    create_table :reviews, id: :uuid do |t|
      t.uuid :product_id, null: false
      t.string :author, null: false
      t.integer :rating, null: false
      t.string :headline, null: false
      t.string :body
      t.timestamps
    end

    add_index :reviews, :product_id
  end
end
