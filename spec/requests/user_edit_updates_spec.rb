require 'rails_helper'

RSpec.describe "ユーザー情報変更", type: :request do

  before do
    @user = User.create!( name:  "Example User",
                 email: "example@railstutorial.org",
                 password: "password",
                 password_confirmation: "password",
                 postal_code: "123-4567",
                 address: "東京都八王子市")
    @user1 = User.create!( name:  "Example User",
                 email: "example1@railstutorial.org",
                 password: "password",
                 password_confirmation: "password",
                 postal_code: "123-4567",
                 address: "東京都八王子市")
  end

  describe "edit" do

    it "ログインが済んでいない場合、ログインページへリダイレクト" do
      get edit_user_path(@user)
      follow_redirect!
      assert_select "div.alert"
      expect(response).to render_template "sessions/new"
    end

    it "正しい場合" do
      log_in_as(@user)
      get edit_user_path(@user)
      expect(response).to have_http_status :success
      expect(response).to render_template "users/edit"
    end

  end

  describe "update" do

    it "ログインが済んでいない場合、ログイン画面へリダイレクト" do
      name = "Example1 User"
      email = "example0@railstutorial.org"
      postal_code = "123-4568"
      address = "東京都八王子町"
      password = "password"
      password_confirmation = "password"
      patch user_path(@user), params: { user: { name:  name,
                   email: email,
                   postal_code: postal_code,
                   address: address,
                   password: password,
                   password_confirmation: password_confirmation} }
      @user.reload
      expect(name).not_to eq @user.name
      expect(email).not_to eq @user.email
      expect(postal_code).not_to eq @user.postal_code
      expect(address).not_to eq @user.address
      follow_redirect!
      assert_select "div.alert"
      expect(response).to render_template "sessions/new"
    end

    it "不正なユーザーでアクセスした場合、homeへリダイレクト" do
      log_in_as(@user)
      name = "Example1 User"
      email = "example2@railstutorial.org"
      postal_code = "123-4568"
      address = "東京都八王子町"
      password = "password"
      password_confirmation = "password"
      patch user_path(@user1), params: { user: {
                   name: name,
                   email: email,
                   postal_code: postal_code,
                   address: address,
                   password: password,
                   password_confirmation: password_confirmation } }
      @user1.reload
      expect(name).not_to eq @user1.name
      expect(email).not_to eq @user1.email
      expect(postal_code).not_to eq @user1.postal_code
      expect(address).not_to eq @user1.address
      follow_redirect!
      expect(flash[:danger].nil?).to be_falsey
      expect(response).to render_template "static_pages/home"
    end

    it "入力情報が不正で,updateに失敗した場合" do
      log_in_as(@user)
      name = ""
      email = "example1@railstutorial.org"
      postal_code = ""
      address = ""
      password = "password"
      password_confirmation = "password"
      patch user_path(@user), params: { user: { name: name,
                   email: email,
                   postal_code: postal_code,
                   address: address,
                   password: password,
                   password_confirmation: password_confirmation } }
      @user.reload
      expect(name).not_to eq @user.name
      expect(email).not_to eq @user.email
      expect(postal_code).not_to eq @user.postal_code
      expect(address).not_to eq @user.address
      assert_select "div#error_explanation"
      expect(response).to render_template "users/edit"
    end

    it "正しい情報でupdateした場合" do
      log_in_as(@user)
      name = "Example1 User"
      email = "example0@railstutorial.org"
      postal_code = "123-4568"
      address = "東京都八王寺町"
      password = "password"
      password_confirmation = "password"
      patch user_path(@user), params: { user: { name: name,
                   email: email,
                   postal_code: postal_code,
                   address: address,
                   password: password,
                   password_confirmation: password_confirmation} }
      @user.reload
      expect(name).to eq @user.name
      expect(email).to eq @user.email
      expect(postal_code).to eq @user.postal_code
      expect(address).to eq @user.address
      follow_redirect!
      expect(flash[:success].nil?).to be_falsey
      expect(response).to render_template "static_pages/home"
    end

  end

end
