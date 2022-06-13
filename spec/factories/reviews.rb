# == Schema Information
#
# Table name: reviews
#
#  id         :uuid             not null, primary key
#  author     :string           not null
#  body       :string
#  headline   :string           not null
#  rating     :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  product_id :uuid             not null
#
# Indexes
#
#  index_reviews_on_product_id  (product_id)
#
FactoryBot.define do
  factory :review do
    author { Faker::Quote.yoda }
    rating { (1..5).to_a.sample }
    headline { Faker::Quote.yoda }
    body { Faker::Quote.yoda }
    association :product
  end
end
