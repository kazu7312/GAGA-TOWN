require 'rails_helper'

RSpec.describe User, type: :model do

  describe "ユーザーモデルの有効性テスト" do

    before do
      @user = User.new(name:  "Example User",
                   email: "example@railstutorial.org",
                   password: "password",
                   password_confirmation: "password",
                   postal_code: "123-4567",
                   address: "東京都八王子市")
    end

    it "正しいユーザー情報が有効と認識されるか" do
      expect(@user).to be_valid
    end

    it "不正な名前のユーザーが無効と認識されるか" do
      @user.name = ""
      expect(@user).not_to be_valid
      @user.name = "a" * 49
      expect(@user).to be_valid
      @user.name = "a" * 50
      expect(@user).to be_valid
      @user.name = "a" * 51
      expect(@user).not_to be_valid
    end

    it "不正なメールアドレスのユーザーが無効と認識されるか" do
      @user.save
      @user1 = User.new(name:  "Example User",
                   email: "Example@railstutorial.org",
                   password: "password",
                   password_confirmation: "password",
                   postal_code: "123-4567",
                   address: "東京都八王子市")
      expect(@user1).not_to be_valid

      @user.email = ""
      expect(@user).not_to be_valid

      @user.email = "a" * 246 + "@foo.org"
      expect(@user).to be_valid
      @user.email = "a" * 247 + "@foo.org"
      expect(@user).to be_valid
      @user.email = "a" * 248 + "@foo.org"
      expect(@user).not_to be_valid

      valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                     first.last@foo.jp alice+bob@baz.cn]
      valid_addresses.each do |valid_address|
        @user.email = valid_address
        assert @user.valid?, "#{valid_address.inspect} should be valid"
      end

      invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                       foo@bar_baz.com foo@bar+baz.com]
      invalid_addresses.each do |invalid_address|
        @user.email = invalid_address
        assert !@user.valid?, "#{invalid_address.inspect} should be invalid"
      end
    end

    it "不正なパスワードのユーザーが無効と認識されるか" do
      @user.password = @user.password_confirmation = ""
      expect(@user).not_to be_valid
      @user.password = @user.password_confirmation = "a" * 5
      expect(@user).not_to be_valid
      @user.password = @user.password_confirmation = "a" * 6
      expect(@user).to be_valid
      @user.password = @user.password_confirmation = "a" * 7
      expect(@user).to be_valid
      @user.password = @user.password_confirmation = "a" * 14
      expect(@user).to be_valid
      @user.password = @user.password_confirmation = "a" * 15
      expect(@user).to be_valid
      @user.password = @user.password_confirmation = "a" * 16
      expect(@user).not_to be_valid
    end

    it "不正な郵便番号のユーザーが無効と認識されるか" do
      @user.postal_code = ""
      expect(@user).not_to be_valid

      @user.postal_code = "123-456"
      expect(@user).not_to be_valid
      @user.postal_code = "123-4567"
      expect(@user).to be_valid
      @user.postal_code = "123-45678"
      expect(@user).not_to be_valid

      invalid_postal_codes = %w[12345678 123-45-6 -1234567 1-234567 12-34567
                        1234-567 12345-67 123456-7 1234567-]
      invalid_postal_codes.each do |invalid_postal_code|
        @user.postal_code = invalid_postal_code
        assert !@user.valid?, "#{invalid_postal_code.inspect} should be invalid"
      end
    end

    it "不正な住所のユーザーが無効と認識されるか" do
      @user.address = ""
      expect(@user).not_to be_valid
      @user.address = "a" * 254
      expect(@user).to be_valid
      @user.address = "a" * 255
      expect(@user).to be_valid
      @user.address = "a" * 256
      expect(@user).not_to be_valid
    end


  end

end
