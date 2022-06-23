class AddRankToProducts < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :rank, :float, default: 0.0
    add_index :products, [:rank, :created_at], name: "index_products_on_rank_desc_created_at_desc", order: { rank: :desc, created_at: :desc }

    reversible do |dir|
      dir.up do
        product_ranker = ProductRanker.new
        Product.all.each{ |product| product_ranker.rank(product) }
      end
    end
  end
end
