# This service is used to call the API's of Open Wheather Map to fetch the data 

require "uri"
require 'net/http'
require 'json'

module Importer
  class WheatherMapImporter < BaseImporter
    attr_reader :appid
    BASE_URL = "http://api.openweathermap.org"

    def initialize
      @appid = Rails.application.credentials.openwheathermap[:api_key] 
      super(BASE_URL)
    end
    
    # This will fetch the locations details i.e. latitude, longitude, state
    def fetch_location_info(q)
      params = { 
          q: q,
          appid: appid, 
          limit: 5, 
        }
      get_request("geo/1.0/direct", params)
    end
    
    # This will return the current air pollution of a location 
    def fetch_current_air_pollution(lat, lon)
      params = { 
          lat: lat,
          lon: lon, 
          appid: appid, 
        }
      get_request("data/2.5/air_pollution", params)
    end
    
    # This will return the history of a location with the given start_date and end_date
    def fetch_air_pollution_history(lat, lon, start_date, end_date)
      params = { 
          lat: lat,
          lon: lon, 
          start: start_date,
          end: end_date,
          appid: appid, 
        }
      get_request("data/2.5/air_pollution/history", params)
    end
  end
end
