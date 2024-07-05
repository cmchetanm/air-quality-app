class CreateLocationsJob < ApplicationJob
  queue_as :default
  
  # This will create list of locations 
  def perform(*args)
    LOCATIONS.each do |location|
      city_name = location[:city_name].downcase
      country_code = location[:country_code]

      unless Location.exists?(city_name: city_name)
        LocationService.new.fetch_location_information(city_name, country_code)
      end
    end
  end

end
