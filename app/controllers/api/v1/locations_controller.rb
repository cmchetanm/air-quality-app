module Api
  module V1
    class LocationsController < ApplicationController
      before_action :get_locations, only: [:avg_aqi_per_month_and_location, :average_aqi_per_location, :average_aqi_per_state]
      before_action :set_location, only: [:fetch_air_pollution]
      
      # Fetch all the locations
      def index
        locations = Location.all
        if locations.blank?
          raise ActiveRecord::RecordNotFound, "No locations found"
        end
        render json: locations, each_serializer: LocationSerializer
      end


      def fetch_air_pollution
        # If the locations passed in params in already stored in database then it will fetch the data from database
        if @location.present?
          air_pollution_data = @location.air_pollution_data
          if air_pollution_data.present?
            render json: @location, each_serializer: LocationSerializer
          else
            raise ActiveRecord::RecordNotFound, "No data found"
          end
        else
        # If location is not present then it will call OpenWheatherMap API from Importer to fetch  and store the location's data
          location = LocationService.new.fetch_location_information(params["city_name"].downcase, params["country_code"])
          render json: location, each_serializer: LocationSerializer
        end
      end
      
      
      # Get the average of AQI per month per location
      def avg_aqi_per_month_and_location
        get_avg_data(AirPollutionDatum.get_aqi_avg_per_month_per_location)
      end
      
      # Get the average of AQI per location
      def average_aqi_per_location
        get_avg_data(AirPollutionDatum.get_avg_per_location)
      end
      
      # Get the average of AQI per state
      def average_aqi_per_state
        get_avg_data(Location.get_avg_per_state)
      end

      private
      
      # It will check the passed location in params and return if the location if already present and if no params found it will fetch stored location's data
      def set_location
        city_name_present = params[:city_name].present?
        country_code_present = params[:country_code].present?
        raise ArgumentError, "Argument Missing either city name or country code" unless city_name_present && country_code_present

        if city_name_present && country_code_present
          @location = Location.find_by(city_name: params[:city_name].downcase)
        end
      end

      
      # Get all the locations
      def get_locations
        @locations = Location.all
      end
      
      def get_avg_data(data)
        if @locations.present?
          render json: data.as_json(only: [:id, :location_id, :month, :average_aqi, :state])
        else
          raise ActiveRecord::RecordNotFound, "No locations found"
        end
      end
    end
  end
end