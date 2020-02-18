require_relative 'ether_prices'
require_relative 'slack'
require_relative 'config/initializers/redis.rb'

$percent_diff = -11  # get_price_24hr.round(1)
$price_now = get_price_now
$positive_send_flag = false 
$negative_send_flag = false

puts "Price Now: " + $price_now.to_s
puts "Change is " + $percent_diff.to_s + "%"

def set_send_flag
  if $redis.get("lastrun") == "true"   
    puts "I'm not gonna write anything because I did less than 24 hours ago"
  elsif $percent_diff.abs() >= ENV['ALERT_THRESHOLD'].to_i
      if $percent_diff < 0
        $redis.setex("lastrun", 86400, true)
        $negative_send_flag = true 
        puts 'Aw, fuck. Prices are down by ' + $percent_diff.to_s + '% in last 24 hours. Sell, sell, sell!'
      elsif $percen_diff > 0
        puts 'Boys, Ether prices are changing fast. Up by '+ $percent_diff.to_s + ' in last 24 hours.'
        $redis.setex("lastrun", 86400, true)
        $positive_send_flag = true
      end 
  else
    puts 'Ether is stable, boys.' 
  end
end

def post_if_positive_flag_set
  if $send_flag == true
    post_to_slack_up($percent_diff.to_s, $price_now.to_s)
  end
end

def post_if_negative_flag_set
  if $negative_send_flag == true
    post_to_slack_down($percent_diff.to_s, $price_now.to_s)
  end
end


set_send_flag
post_if_positive_flag_set
post_if_negative_flag_set
