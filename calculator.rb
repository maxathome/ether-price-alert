require_relative 'ether_prices'
require 'time'

$percent_diff = 0
$read_ping_history = File.open('ping_history.txt', 'r')


def percent_difference(current_price, past_price)
  puts "Price Now: " + current_price.to_s
  puts "Past Price: " + past_price.to_s
  difference = (current_price - past_price)
  average = (current_price + past_price) / 2
  unrounded_percent_diff = (difference.abs() / average)* 100
  $percent_diff = unrounded_percent_diff.round(1)
  puts "Change is " + $percent_diff.round(1).to_s + "%"
end

def send_or_not
  if File.zero?($read_ping_history) 
    File.write('ping_history.txt', (Time.now.utc - 86400))
  elsif Time.parse(File.read('ping_history.txt')) - (Time.now.utc - 86400) >= 86000 
    puts "I'm not gonna write anything because I did less than 24 hours ago"
  elsif $percent_diff >= 10
    puts 'Boys, Ether prices are changing fast. Up by '+ $percent_diff.to_s + ' in last 24 hours.'
    File.write('ping_history.txt', (Time.now.utc))
  else
    puts 'Ether is stable, boys.' 
  end
end

percent_difference(get_price_now, get_price_24hr) 
send_or_not
