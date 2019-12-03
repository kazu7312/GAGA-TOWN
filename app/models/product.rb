class Product < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :favorites, foreign_key: 'product_id', dependent: :destroy
  has_many :purchases
  has_many :stocks, dependent: :destroy
  has_many :users, through: :favorites
  belongs_to :category
  belongs_to :brand
  belongs_to :user, optional: true
  default_scope -> {order(created_at: :desc)}

end
