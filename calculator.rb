require_relative 'ether_prices'
require_relative 'slack'
require_relative 'config/initializers/redis.rb'

$percent_diff = get_price_24hr.round(1)
$price_now = get_price_now
$send_flag = false 

puts "Price Now: " + $price_now.to_s
puts "Change is " + $percent_diff.to_s + "%"

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

set_send_flag
post_if_flag_set  
