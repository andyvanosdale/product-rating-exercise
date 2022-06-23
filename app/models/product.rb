# frozen_string_literal: true

# == Schema Information
#
# Table name: products
#
#  id          :uuid             not null, primary key
#  description :string
#  name        :string           not null
#  rank        :float            default(0.0)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_products_on_name                       (name) UNIQUE
#  index_products_on_rank_desc_created_at_desc  (rank,created_at)
#

class Product < ApplicationRecord
  has_many :reviews, dependent: :destroy
end
