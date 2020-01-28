require 'net/http'
require 'uri'
require 'json'
require 'dotenv/load'

def post_to_slack(percent)
  url = ENV['SLACK_HOOK']
  uri = URI(url)
  request = Net::HTTP::Post.new(uri)
  request.content_type = "application/json"
  request.body = JSON.dump({
   "text" => ":loud_sound: Hey <!channel>! Etherium has moved "+ percent + "% in the last 24 hours! :loud_sound:"
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

post_to_slack("12")
