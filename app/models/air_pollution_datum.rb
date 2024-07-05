class AirPollutionDatum < ApplicationRecord
  belongs_to :location
  
  # This method will return the average data per month per location 
  def self.get_aqi_avg_per_month_per_location
    joins(:location)
      .select('location_id, DATE_TRUNC(\'month\', air_pollution_data.created_at) AS month, AVG(aqi) AS average_aqi')
      .group('location_id, DATE_TRUNC(\'month\', air_pollution_data.created_at)')
      .order('location_id, month')
  end  
  
  # This method will return the average data per location
  def self.get_avg_per_location
    joins(:location)
      .select('location_id, AVG(aqi) AS average_aqi')
      .group('location_id')
      .order('location_id')
  end
end

