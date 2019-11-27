class Size < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :stocks, dependent: :destroy
end
