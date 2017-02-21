require 'httparty'
require 'dotenv/load'
require 'byebug'
require_relative 'file_cache'

class WeatherTracker
  def initialize(zip_code)
    @api_key = ENV['API_KEY']
    @page = {}
    @forecast = {}
    @zip_code = zip_code
  end

  def get_all
    load_weather_info
    set_time
    set_current
    set_ten_day
    set_sun_phase
    set_alerts
    set_hurricanes
  end

  def load_weather_info
    cache = FileCache.new 'cache.txt'

    # TODO: check cache age
    if cache.key? @zip_code
      @page = cache.get @zip_code
    else
      @page = HTTParty.get "http://api.wunderground.com/api/#{@api_key}/features/alerts/astronomy/conditions/currenthurricane/forecast10day/q/#{@zip_code}.json"
      cache.set @zip_code, @page
    end
  end

  def set_time
    @forecast[:time] = @page['current_observation']['observation_time_rfc822']
  end

  def set_current
    @forecast[:current] = {
      temperature: @page['current_observation']['temperature_string'],
      weather: @page['current_observation']['weather']
    }
  end

  def set_ten_day
    @forecast[:ten_day] = @page['forecast']['txt_forecast']['forecastday'].map do |period|
      { period: period['period'], title: period['title'], forecast: period['fcttext'] }
    end
  end

  def set_sun_phase
    @forecast[:sun_phase] = @page['sun_phase']
  end

  def set_alerts
    @forecast[:alerts] = @page['alerts']
  end

  def set_hurricanes
    @forecast[:hurricanes] = @page['currenthurricane'].map do |hurricane|
      { storm_info: hurricane['stormInfo'] }
    end
  end
end
