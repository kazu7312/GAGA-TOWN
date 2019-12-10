require 'rails_helper'

RSpec.describe "StaticPageHomes", type: :request do
  describe "GET /static_page_homes" do
    it "works! (now write some real specs)" do
      get static_page_homes_path
      expect(response).to have_http_status(200)
    end
  end
end
