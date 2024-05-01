require 'net/http'
require 'json'
require 'dotenv/load'


def get_price_now()
  url = ENV['GET_PRICE_URL'] + ENV['CYRPTOCOMPARE_API_KEY']
  uri = URI(url)
  response = Net::HTTP.get(uri)
  value = JSON.parse(response)
  value["USD"]
end

def get_price_24hr()
  url = ENV['GET_PRICE_24HR_URL'] + ENV['CYRPTOCOMPARE_API_KEY']
  uri = URI(url)
  response = Net::HTTP.get(uri)
  value = JSON.parse(response)
  value["RAW"]["CHANGEPCT24HOUR"]
end

