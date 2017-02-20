require 'httparty'
require 'dotenv/load'
require 'byebug'
require_relative 'file_cache'

def main
  puts 'Enter zip: '
  zip_code = gets.chomp

  forecast = get_ten_day(zip_code)
  p forecast
end

def get_ten_day(zip_code)
  cache = FileCache.new 'cache.txt'
  api_key = ENV['API_KEY']

  # TODO: check cache age
  return cache.get zip_code if cache.key? zip_code

  forecast = HTTParty.get "http://api.wunderground.com/api/#{api_key}/forecast10day/q/#{zip_code}.json"

  ten_day = forecast['forecast']['txt_forecast']['forecastday'].map do |period|
    { period: period['period'], title: period['title'], forecast: period['fcttext'] }
  end

  cache.set zip_code, ten_day

  ten_day
end

main if __FILE__ == $PROGRAM_NAME
