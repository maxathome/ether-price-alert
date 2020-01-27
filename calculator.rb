require_relative 'ether_prices'

$percent_diff = 10
$write_ping_history = File.open('ping_history.txt', 'w+')
$read_ping_history = File.open('ping_history.txt', 'r')
# $write_ping_history.puts Time.now.utc
# $write_ping_history.close
# puts $read_ping_history.read


def percent_difference()
  price_now = get_price_now
  price_24hr = get_price_24hr
  puts "Price Now: " + price_now.to_s
  puts "Price 24 Hours Ago: " + price_24hr.to_s
  difference = (price_now - price_24hr)
  average = (price_now + price_24hr) / 2
  unrounded_percent_diff = (difference.abs() / average)* 100
  $percent_diff = unrounded_percent_diff.round(1)
  # puts "24h change is " + $percent_diff.round(1).to_s + "%"
end

# percent_difference()


def send_or_not()
  loop do
    if File.readlines("ping_history.txt").grep(/monitor/).size == 0
      File.write('ping_history.txt', Time.now.utc)
      puts "This is the file check: " + $read_ping_history.read
      break
    elsif $read_ping_history.read < (Time.now.utc - 86400).to_s
       puts "I'm not gonna write anything because I did less than 24 hours ago"
       break
    elsif $percent_diff >= 10
       puts 'Boys, Ether prices are changing fast. Up by '+ $percent_diff.to_s + ' in last 24 hours.'
       $write_ping_history.puts Time.now.utc
       break
       # $write_ping_history.close
    else
       puts 'Ether is stable, boys.'
       break
    end
  end
end


send_or_not

# read_ping_history = File.open('ping_history.txt', &:gets)
# puts read_ping_history.read
