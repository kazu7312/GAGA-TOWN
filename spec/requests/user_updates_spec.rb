require 'rails_helper'

RSpec.describe "ユーザー登録", type: :request do

  it "不正な入力の場合、ユーザー登録に失敗" do
    count = User.count
    post signup_path, params: { user: {name:  "",
                 real_name: "",
                 email: "example@invalid",
                 password: "bar",
                 password_confirmation: "foo",
                 postal_code: "123-4567",
                 address: "" } }
    expect(count).to eq User.count
    assert_select "div#error_explanation"
    expect(response).to render_template "users/new"
  end

  it "正しい登録の場合、ユーザー登録に成功" do
    count = User.count
    post signup_path, params: { user: {name:  "Example User",
                 real_name: "Example",
                 email: "example@railstutorial.org",
                 password: "password",
                 password_confirmation: "password",
                 code: "123-4567",
                 address: "東京都八王子市"} }
    expect(count).to eq User.count + 1
    follow_redirect!
    expect(response).to render_template "static_pages/home"
    assert_select "div.alert"
  end

end
