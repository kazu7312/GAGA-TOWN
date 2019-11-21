class Product < ApplicationRecord
  has_many :carts, dependent: :destroy
  has_many :stocks, dependent: :destroy
  has_many :favorites, dependent: :destroy
  belongs_to :category
  belongs_to :brand
  default_scope -> {order(created_at: :desc)}

  # def self.word_search(word_search)
  #   Product.select(product.name, category.name, brand.name, price, icon).where("product.name LIKE ?", "#{word_search}%")
  # end
  #

#select(products.name, categorys.name, brands.name, price, icon).
end
