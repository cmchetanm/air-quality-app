class LocationService
  
  # This will fetch the location's details i.e. latitude, longitude and save it to database
  def fetch_location_information(city, country_code)
 	  response = open_wheather_map.fetch_location_info("#{city},#{country_code}")
    location = create_location(response)
    fetch_air_pollution_data(location)
    location
  end
  
  # This will call the method which will fetch the location's air pollution data
  def fetch_and_create_air_pollution(location)
    fetch_air_pollution_data(location)
  end
  
  # This will save the air pollution histories of the for a particular location
  def save_history_data(response, location)
    response['list'].each do |data|
      dt = Time.at(data['dt'])
      next if AirPollutionHistory.exists?(location_id: location.id, dt: dt.beginning_of_month..dt.end_of_month)
      create_pollution_histories(location, data)
    end
  end

  private
  

  # This will create  the location
  def create_location(response)
		location_info = {
      city_name: response[0]["name"].downcase,
      latitude: response[0]["lat"],
      longitude: response[0]["lon"],
      state: response[0]["state"]
    }
    Location.create(location_info)
  end
  
  # This will fetch the location's air pollution data
  def fetch_air_pollution_data(location)
    response = open_wheather_map.fetch_current_air_pollution(location[:latitude], location[:longitude])
    air_pollution_data = create_air_pollution_data(location, response)
  end

  # This will create air pollution data for the location
  def create_air_pollution_data(location, response)
  	data = response["list"][0]
    air_pollution_data = create_pollution_data(data)
    location.air_pollution_data.create(air_pollution_data)
  end
  
  # This will create the air pollution history for the location
  def create_pollution_histories(location, data)
    pollution_history = create_pollution_data(data)
    location.air_pollution_histories.create(pollution_history)
  end
  
  # This will return hash for the air pollution data
  def create_pollution_data(data)
    component = data['components']
    {
      aqi: data['main']['aqi'],
      co: component['co'],
      no: component['no'],
      no2: component['no2'],
      o3: component['o3'],
      so2: component['so2'],
      pm2_5: component['pm2_5'],
      pm10: component['pm10'],
      nh3: component['nh3'],
      dt: Time.at(data['dt'])
    }
  end

  def open_wheather_map
  	@open_wheather_map ||= Importer::WheatherMapImporter.new
  end
end
