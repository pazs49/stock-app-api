require "rails_helper"

RSpec.describe "Stocks API", type: :request do
  describe "Stocks API" do
    let(:user) { FactoryBot.create(:user) }

    describe "Searching for stocks" do
      it "returns searched stocks with a successful status code" do
        headers = auth_headers_for(user)

        post "/api/v1/stocks/search", params: { symbol: "IBM" }.to_json, headers: headers

        expect(response).to have_http_status(:success)
      end
    end

    describe "Retrieving stocks" do
      it "returns a list of stocks with a successful status code" do
        headers = auth_headers_for(user)

        get "/api/v1/stocks", headers: headers
        expect(response).to have_http_status(:success)

        json_response = JSON.parse(response.body)
        puts json_response["data"]
        expect(json_response["data"]).to be_an(Array)
      end
    end

    describe "Buying stocks" do
      it "buys stocks and updates the user's stock quantity" do
        headers = auth_headers_for(user)

        post "/api/v1/stocks/buy", params: { symbol: "AAPL", stock_qty: 10 }.to_json, headers: headers

        expect(response).to have_http_status(:success)

        expect(user.user_info.stocks.find_by(name: "AAPL").qty).to eq(10)
      end
    end

    describe "Selling stocks" do
      it "sells stocks and updates the user's stock quantity" do
        headers = auth_headers_for(user)

        stock = Stock.create(name: "IBM", price: 100, qty: 10)
        user.user_info.stocks << stock

        post "/api/v1/stocks/sell", params: { symbol: "IBM", stock_qty: 5 }.to_json, headers: headers

        expect(response).to have_http_status(:success)

        expect(user.user_info.stocks.find_by(name: "IBM").qty).to eq(5)
      end
    end
  end
end
