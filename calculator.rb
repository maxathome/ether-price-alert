require_relative 'ether_prices'
require_relative 'slack'
require_relative 'config/initializers/redis.rb'
require 'time'
require 'redis'

# $redis = Redis.new(url: ENV['REDIS_URL'])
$percent_diff = 0
$price_now = 0
$send_flag = false 

def percent_difference(current_price, past_price)
  puts "Price Now: " + current_price.to_s
  puts "Past Price: " + past_price.to_s
  $price_now = current_price 
  difference = (current_price - past_price)
  average = (current_price + past_price) / 2
  unrounded_percent_diff = (difference.abs() / average)* 100
  $percent_diff = unrounded_percent_diff.round(1)
  puts "Change is " + $percent_diff.round(1).to_s + "%"
end

def set_send_flag
  if $redis.get("lastrun") == "true"   
    puts "I'm not gonna write anything because I did less than 24 hours ago"
  elsif $percent_diff >= ENV['ALERT_THRESHOLD'].to_i
    puts 'Boys, Ether prices are changing fast. Up by '+ $percent_diff.to_s + ' in last 24 hours.'
    $redis.setex("lastrun", 86400, true)
    $send_flag = true
  else
    puts 'Ether is stable, boys.' 
  end
end

def post_if_flag_set
  if $send_flag == true
    post_to_slack($percent_diff.to_s, $price_now.to_s)
  end
end

percent_difference(get_price_now, get_price_24hr) 
set_send_flag
post_if_flag_set  
