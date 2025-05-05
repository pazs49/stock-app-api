require "net/http"
require "uri"
require "json"

class AvaApi
  def self.fetch_stock_data
    url = URI("https://alpha-vantage.p.rapidapi.com/query?function=TIME_SERIES_DAILY&symbol=MSFT&outputsize=compact&datatype=json")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request["x-rapidapi-key"] = 'c18b9f25bamsh9e670a457ebbdc8p16ba24jsn9c9752e830af'
    request["x-rapidapi-host"] = 'alpha-vantage.p.rapidapi.com'

    response = http.request(request)
    JSON.parse(response.body)
  end
end git merge your-branch-name