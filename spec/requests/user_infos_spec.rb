require 'rails_helper'

RSpec.describe "UserInfos", type: :request do
  describe "User Infos" do
    let(:user) { FactoryBot.create(:user) }
    describe "Retrieving User Info" do
      it "returns searched stocks with a successful status code" do
        headers = auth_headers_for(user)

        post "/api/v1/stocks/search", params: { symbol: "IBM" }.to_json, headers: headers

        expect(response).to have_http_status(:success)
      end
    end
  end
end
