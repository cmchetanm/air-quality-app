# spec/services/location_service_spec.rb
require 'rails_helper'

RSpec.describe LocationService, type: :service do
  let(:city) { 'London' }
  let(:country_code) { 'GB' }
  let(:location_service) { described_class.new }
  let(:location) { Location.create(city_name: city.downcase, latitude: 51.5074, longitude: -0.1278, state: 'England') }

  describe '#fetch_location_information' do
    it 'creates a location and fetches air pollution data', :vcr do
      VCR.use_cassette('fetch_location_information', record: :new_episodes, record: :new_episodes) do
        location = location_service.fetch_location_information(city, country_code)
        expect(location.city_name).to eq(city.downcase)
        expect(location.air_pollution_data).not_to be_empty
      end
    end
  end

  describe '#fetch_and_create_air_pollution' do
    it 'fetches and creates air pollution data for an existing location', :vcr do
      VCR.use_cassette('fetch_and_create_air_pollution', record: :new_episodes) do
        location_service.fetch_and_create_air_pollution(location)
        expect(location.air_pollution_data).not_to be_empty
        expect(location.air_pollution_data.last.location_id). to eq(location.id)
      end
    end
  end

  describe '#save_history_data' do
    it 'save air pollution data if it already exists for the given month', :vcr do
      VCR.use_cassette('save_history_data', record: :new_episodes) do
        open_wheather_map ||= Importer::WheatherMapImporter.new
        response = open_wheather_map.fetch_air_pollution_history(location.latitude, location.longitude, (Time.now - 11.month).to_i, Time.now.to_i)
        location_service.save_history_data(response, location)
        initial_count = location.air_pollution_histories.count
        location_service.save_history_data(response, location)
        expect(response['list'].first["components"]["co"]).to eq(247)
      end
    end
  end
end
