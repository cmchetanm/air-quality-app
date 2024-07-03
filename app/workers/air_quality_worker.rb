# app/workers/example_worker.rb
class AirQualityWorker
  include Sidekiq::Worker
  
  # This background job is to fetch the air pollution data per location per month or 30 seconds and store it in database
  def perform()
    locations = Location.all
    locations.each do |location|  
      LocationService.new.fetch_and_create_air_pollution(location)
    end if locations.present?
  end
end
