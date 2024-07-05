# app/workers/example_worker.rb
class AirPollutionHistoryWorker
  include Sidekiq::Worker
  
  # this background job will store the data of location for the last 1 year per month and store it in database 
  def perform()
   locations = Location.all  
    locations.each do |location|
      start_date = Time.now - 11.month
      end_date = Time.now
      pollution_history = Importer::WheatherMapImporter.new.fetch_air_pollution_history(location.latitude, location.longitude, start_date.to_i, end_date.to_i)
      LocationService.new.save_history_data(pollution_history, location)
    end if locations.present?
  end

end
