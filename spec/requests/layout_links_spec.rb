require 'rails_helper'

RSpec.describe "レイアウト周りのテスト", type: :request do

  before do
    post signup_path, params: { user: {name:  "Example User",
                  name:  "Example User",
                  email: "example@railstutorial.org",
                  password: "password",
                  password_confirmation: "password",
                  postal_code: "123-4567",
                  address: "東京都八王子市"
                 }
               }
    @user = User.first
    @cart = Cart.create!(user_id: @user.id)
    # @user.update_attribute(:activated, true)
    # @order = Order.create(user_id: @user.id, ordered_at: Time.zone.now)
  end

  it "ログイン前のレイアウト" do
    get root_path
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", signup_path
    assert_select "a[href=?]", login_path
  end

  it "ログイン後のレイアウト" do
    log_in_as(@user)
    get root_url
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", "/cart/#{@cart.id}"
    assert_select "a[href=?]", edit_user_path(@user)
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", "/users/#{@user.id}/likes"
    assert_select "a[href=?]", purchases_path(@user)
    assert_select "a[href=?]", signup_path, count: 0
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", search_path
  end

end
