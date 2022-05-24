def color(index)
  normal = "\e[#{index}m#{index}\e[0m"
  bold = "\e[#{index}m\e[1m#{index}\e[0m"
  "#{normal}  #{bold}  "
end

8.times do|index|
  line = color(index + 1)
  line += color(index + 30)
  line += color(index + 90)
  line += color(index + 40)
  line += color(index + 100)
  puts line
end

heart = "\u2665"
puts "\e[44m   #{heart}   \e[0m"

knight = "\u2658"
black_knight = "\e[30m\u2658\e[1m"

puts "\e[44m   #{knight}   \e[0m"
puts "\e[44m#{black_knight}\e[0m"