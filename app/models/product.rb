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
  mount_uploader :icon, IconUploader
  validate :icon_size
  validates :name, presence: :true, length: { maximum: 255 }
  validates :category_id, presence: :true
  validates :brand_id, presence: :true
  validates :price, presence: :true, numericality: { more_than_or_equal_to: 0 }
  validates :detail, presence: :true, length: { maximum: 500 }

end
