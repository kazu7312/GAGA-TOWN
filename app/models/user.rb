class User < ApplicationRecord
  has_many :purchases
  has_many :carts, dependent: :destroy
  has_many :favorites
  has_many :products
  has_many :favproducts, through: :favorites, source: :product

  attr_accessor :remember_token
  before_save :downcase_email
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  #VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  VALID_POSTAL_CODE_REGEX = /\A\d{3}[-]\d{4}\z/
  validates :postal_code, presence: true, length: { is: 8 },
                    format: { with: VALID_POSTAL_CODE_REGEX }
  validates :address, presence: true, length: { maximum: 255 }
  has_secure_password
  validates :password, presence: true, length: { in: 6..15 }

  # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返す
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # 永続セッションのためにユーザーをデータベースに記憶する
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

 # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end


 #お気に入り周りの機能
  def like(product)
    favorites.find_or_create_by(product_id: product.id)
  end

  def unlike(product)
    favorite = favorites.find_by(product_id: product.id)
    favorite.destroy if favorite
  end

  #お気に入り判定
  def favproduct?(product)
    self.favproducts.include?(product)
  end

  private

    def downcase_email
      self.email = email.downcase
    end
end
