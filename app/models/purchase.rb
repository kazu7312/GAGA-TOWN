class Purchase < ApplicationRecord
  belongs_to :user
  has_many :items
  has_many :products, through: :items
  belongs_to :product, optional: true

  validates :destination_name, presence: true, length: { maximum: 255 }
  VALID_CODE_REGEX = /\A[0-9]+[0-9]+[0-9]+[-]+[0-9]+[0-9]+[0-9]+[0-9]\z/i
  validates :destination_postal_code, presence: true, length: { is: 8 }, format: { with: VALID_CODE_REGEX }
  validates :destination_address, presence: true, length: { maximum: 255 }
  validates :credit_number, presence: true, length: { in: 14..16 }
  mount_uploader :icon, IconUploader
  validate :icon_size

end
