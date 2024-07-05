class Location < ApplicationRecord
	has_many :air_pollution_data, dependent: :destroy
  has_many :air_pollution_histories, dependent: :destroy
  
  # This will return average data per state
  def self.get_avg_per_state
    joins(:air_pollution_data)
      .select('locations.id, locations.state, AVG(air_pollution_data.aqi) AS average_aqi')
      .group('locations.id, locations.state')
      .order('locations.state')
  end

end
