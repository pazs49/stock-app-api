require "net/http"
require "uri"
require "json"

class Api::V1::StocksController < ApplicationController
  before_action :authenticate_devise_api_token!

  def search
    symbol = params[:symbol] || "IBM"

    if symbol.upcase == "IBM"
      render json: {
        "Meta Data": {
          "1. Information": "Daily Prices (open, high, low, close) and Volumes",
          "2. Symbol": "IBM",
          "3. Last Refreshed": "2025-04-29",
          "4. Output Size": "Compact",
          "5. Time Zone": "US/Eastern",
        },
        "Time Series (Daily)": {
          "2025-04-29": {
            "1. open": "145.25",
            "2. high": "146.50",
            "3. low": "144.75",
            "4. close": "145.50",
            "5. volume": "4500000",
          },
        },
      }
    else
      render json: { error: "Invalid symbol" }, status: :bad_request
    end

    #Uncomment on live
    # api_key = ENV["ALPHA_STOCK_API_KEY"]
    # url = URI("https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=#{symbol}&apikey=#{api_key}")

    # response = Net::HTTP.get_response(url)

    # if response.is_a?(Net::HTTPSuccess)
    #   data = JSON.parse(response.body)
    #   render json: data
    # else
    #   render json: { error: "Failed to fetch stock data" }, status: :bad_request
    # end
  end
end
