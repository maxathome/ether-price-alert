require 'net/http'
require 'uri'
require 'json'
require 'dotenv/load'

def post_to_slack(percent, current_price)
  url = ENV['SLACK_HOOK']
  uri = URI(url)
  request = Net::HTTP::Post.new(uri)
  request.content_type = "application/json"
  request.body = JSON.dump({
   "text" => ":eggplant: Hey lambo fans! Etherium has moved "+ percent + "% in the last 24 hours! Price is currently at $" + current_price + "! :eggplant:"
  })

  req_options = {
    use_ssl: uri.scheme == "https",
  }
 
  response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
  http.request(request)
  end
  puts response.code
  puts response.body
end
