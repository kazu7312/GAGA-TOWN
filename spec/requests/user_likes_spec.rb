require 'rails_helper'

RSpec.describe "UserLikes", type: :request do
  describe "GET /user_likes" do
    it "works! (now write some real specs)" do
      get user_likes_index_path
      expect(response).to have_http_status(200)
    end
  end
end
