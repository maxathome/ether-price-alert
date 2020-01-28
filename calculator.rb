require_relative 'ether_prices'
require_relative 'slack'
require 'time'
require 'redis'

$redis = Redis.new(host: ENV['REDIS_HOST'], port: ENV['REDIS_PORT'], password: ENV['REDIS_PASSWORD'], user: ENV['REDIS_USER'])
$percent_diff = 0
$send_flag = false 

def percent_difference(current_price, past_price)
  puts "Price Now: " + current_price.to_s
  puts "Past Price: " + past_price.to_s
  difference = (current_price - past_price)
  average = (current_price + past_price) / 2
  unrounded_percent_diff = (difference.abs() / average)* 100
  $percent_diff = unrounded_percent_diff.round(1)
  puts "Change is " + $percent_diff.round(1).to_s + "%"
end

def set_send_flag
  if $redis.get("lastrun") == nil  
    $redis.set("lastrun", (Time.now.utc - 86400))
  elsif Time.parse($redis.get("lastrun")) - (Time.now.utc - 86400) >= 86000 
    puts "I'm not gonna write anything because I did less than 24 hours ago"
  elsif $percent_diff >= ENV['ALERT_THRESHOLD'].to_i
    puts 'Boys, Ether prices are changing fast. Up by '+ $percent_diff.to_s + ' in last 24 hours.'
    $redis.set("lastrun", Time.now.utc)
    $send_flag = true
  else
    puts 'Ether is stable, boys.' 
  end
end

def post_if_flag_set
  if $send_flag == true
    post_to_slack($percent_diff.to_s, current_price.to_s)
  end
end

percent_difference(get_price_now, get_price_24hr) 
set_send_flag
post_if_flag_set  
