require_relative 'weather_tracker'

def main
  puts 'Enter zip: '
  zip_code = gets.chomp

  weather = WeatherTracker.new zip_code

  weather.get_all

  puts weather.to_s
end

main if __FILE__ == $PROGRAM_NAME
