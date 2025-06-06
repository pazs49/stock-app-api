require "net/http"
require "uri"
require "json"

class Api::V1::StocksController < ApplicationController
  before_action :authenticate_devise_api_token!
  before_action :set_devise_api_token, only: [:index, :buy, :sell, :update_stock_price]

  def index
    user = User.find(@devise_api_token.resource_owner_id)
    @stocks = user.user_info.stocks
    render json: @stocks
  end

  def search
    symbol = params[:symbol] || "IBM"

    # Comment out on live
    # if symbol.upcase == "IBM"
    #   render json: {
    #     "Meta Data": {
    #       "1. Information": "Daily Prices (open, high, low, close) and Volumes",
    #       "2. Symbol": "IBM",
    #       "3. Last Refreshed": "2025-04-29",
    #       "4. Output Size": "Compact",
    #       "5. Time Zone": "US/Eastern",
    #     },
    #     "Time Series (Daily)": {
    #       "2025-04-29": {
    #         "1. open": "145.25",
    #         "2. high": "146.50",
    #         "3. low": "144.75",
    #         "4. close": "145.50",
    #         "5. volume": "4500000",
    #       },
    #     },
    #   }
    # else
    #   render json: { error: "Invalid symbol" }, status: :bad_request
    # end
    # Comment out on live

    # Uncomment on live
    stock_data = fetch_stock_data(symbol)

    if stock_data.is_a?(Net::HTTPSuccess)
      data = JSON.parse(stock_data.body)
      render json: data
    else
      render json: { error: "Failed to fetch stock data" }, status: :bad_request
    end
    # Uncomment on live
  end

  def buy
    process_stock_transaction(params[:stock_qty].to_i, true)
  end

  def sell
    process_stock_transaction(params[:stock_qty].to_i, false)
  end

  def update_stock_price
    user = User.find(@devise_api_token.resource_owner_id)

    symbol = params[:symbol]

    stock_data = fetch_stock_data(symbol)

    if stock_data.is_a?(Net::HTTPSuccess)
      data = JSON.parse(stock_data.body)
      latest_data = data["Time Series (Daily)"].keys.first
      latest_price = data["Time Series (Daily)"][latest_data]["4. close"].to_f

      stock = user.user_info.stocks.find_by(name: symbol)
      if stock
        stock.price = latest_price
        stock.save!
        render json: stock
      else
        render json: { error: "Stock not found" }, status: :not_found
      end
    else
      render json: { error: "Server error" }, status: :not_found
    end
  end

  private

  def process_stock_transaction(stock_qty, is_buy)
    user = User.find(@devise_api_token.resource_owner_id)

    if stock_qty <= 0
      render json: { error: "Invalid stock quantity" }, status: :bad_request
      return
    end

    symbol = params[:symbol]
    stock_data = fetch_stock_data(symbol)

    if stock_data.is_a?(Net::HTTPSuccess)
      data = JSON.parse(stock_data.body)

      # Check for rate limit message
      if data.key?("Note") || data.key?("Information")
        Rails.logger.error "Alpha Vantage API limit reached: #{data.inspect}"
        render json: { error: "Service temporarily unavailable. Please try again later." }, status: :service_unavailable
        return
      end

      # Check for missing data structure
      if !data.key?("Time Series (Daily)") || data["Time Series (Daily)"].empty?
        Rails.logger.error "Invalid API response format: #{data.inspect}"
        render json: { error: "Unable to retrieve stock data. Please try again later." }, status: :bad_request
        return
      end

      latest_data = data["Time Series (Daily)"].keys.first
      latest_price = data["Time Series (Daily)"][latest_data]["4. close"].to_f

      total_price = latest_price * stock_qty

      if is_buy && user.user_info.balance < total_price
        render json: { error: "Insufficient balance" }, status: :bad_request
        return
      end

      stock = user.user_info.stocks.find_by(name: symbol)

      if stock
        stock.price = latest_price
        if is_buy
          stock.qty += stock_qty
        else
          if stock.qty < stock_qty
            render json: { error: "Insufficient stock quantity" }, status: :bad_request
            return
          end
          stock.qty -= stock_qty
        end
        stock.save!
      else
        if is_buy
          stock = Stock.create(name: symbol, qty: stock_qty, price: latest_price)
          user.user_info.stocks << stock
        else
          render json: { error: "You don't own this stock" }, status: :bad_request
          return
        end
      end

      user.user_info.balance += total_price if !is_buy
      user.user_info.balance -= total_price if is_buy

      transaction = Transaction.new(
        name: symbol,
        action: is_buy ? "buy" : "sell",
        date: Time.current,
        price: latest_price,
        qty: stock_qty,
        user_info_id: user.user_info.id,
      )
      transaction.save

      if user.user_info.save
        render json: { message: "Stock #{is_buy ? "bought" : "sold"} successfully" }, status: :ok
      else
        render json: { error: "Failed to save user info" }, status: :bad_request
      end
    else
      render json: { error: "Failed to fetch stock data" }, status: :bad_request
    end
  end

  def set_devise_api_token
    @devise_api_token = current_devise_api_token
  end

  def fetch_stock_data(symbol)
    api_key = ENV["ALPHA_STOCK_API_KEY"]
    url = URI("https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=#{symbol}&apikey=#{api_key}")

    response = Net::HTTP.get_response(url)

    response
  end
end
