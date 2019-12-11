require 'rails_helper'

RSpec.describe "ログイン・ログアウト", type: :request do


  before do
    @user = User.create!( name:  "Example User",
                 email: "example@railstutorial.org",
                 password: "password",
                 password_confirmation: "password",
                 postal_code: "123-4567",
                 address: "東京都八王子市")


    # post signup_path, params: { user: {name:  "Example User",
    #              email: "example@railstutorial.org",
    #              password: "password",
    #              password_confirmation: "password",
    #              postal_code: "123-4567",
    #              address: "東京都八王子市"} }
    # @user = User.first
  end


  it "不正なログイン" do
    post login_path, params: { session: { email:    "user@invalid",
                                      password: "" } }
    expect(is_logged_in?).to be_falsey
    assert_select "div.alert"
    expect(response).to render_template "sessions/new"
  end

  it "正常なログイン" do
    log_in_as(@user)
    expect(is_logged_in?).to be_truthy
    follow_redirect!
    expect(response).to render_template "static_pages/home"
  end

  it "正常なログアウト" do
    log_in_as(@user)
    delete logout_path(@user)
    expect(is_logged_in?).to be_falsey
    follow_redirect!
    expect(response).to render_template "static_pages/home"
  end

  it "ログアウトされた状態でのログアウト" do
    delete logout_path
    expect(is_logged_in?).to be_falsey
    follow_redirect!
    expect(response).to render_template "static_pages/home"
  end

  it "リメンバーミー機能のテスト" do
    log_in_as(@user, remember_me: '1')
    expect(is_logged_in?).to be_truthy
    expect(cookies['remember_token'].empty?).to be_falsey
  end

  it "リメンバーミー機能を用いない時のログイン" do
    log_in_as(@user, remember_me: '1')
    delete logout_path
    log_in_as(@user, remember_me: '0')
    expect(is_logged_in?).to be_truthy
    expect(cookies['remember_token'].empty?).to be_truthy
  end

  it "不正なクッキーが存在する時のログイン挙動" do
    log_in_as(@user, remember_me: '1')
    session[:user_id] = nil
    @user.update_attribute(:remember_digest, User.digest(User.new_token))
    redirect_to root_path
    expect(is_logged_in?).to be_falsey
    assert_select "a[href=?]", logout_path, count: 0
  end


  # it "current_user returns right user when session is nil" do
  #   remember(@user)
  #   expect(@user).to eq current_user
  #   expect(is_logged_in?).to be_truthy
  # end
  #
  # it "current_user returns nil when remember digest is wrong" do
  #   @user.update_attribute(:remember_digest, User.digest(User.new_token))
  #   expect(@user).not_to eq current_user
  # end
  #
  # it "フレンドリーフォワーディング" do
  #   get "purchases/#{@user.id}/show"
  #   log_in_as(@user)
  #   follow_redirect!
  #   expect(response).to render_template "purchases/#{@user.id}/show"
end
