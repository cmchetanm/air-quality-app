require 'rails_helper'
require 'vcr'

RSpec.describe Importer::WheatherMapImporter, type: :service do
  let(:importer) { Importer::WheatherMapImporter.new }

  describe '#fetch_location_info' do
    it 'fetches location info from the API' do
      VCR.use_cassette('fetch_location_info', record: :new_episodes) do
        response = importer.fetch_location_info('Mumbai,IN')
        expect(response).not_to be_nil
        expect(response.first['name']).to eq('Mumbai')
      end
    end
  end

  describe '#fetch_current_air_pollution' do
    it 'fetches current air pollution data from the API' do
      VCR.use_cassette('fetch_current_air_pollution', record: :new_episodes) do
        response = importer.fetch_current_air_pollution(19.0760, 72.8777) # Coordinates for Mumbai
        expect(response).not_to be_nil
        expect(response['list'].first['main']['aqi']).to eq(2)
      end
    end
  end

  describe '#fetch_air_pollution_history' do
    it 'fetches air pollution history data from the API' do
      VCR.use_cassette('fetch_air_pollution_history', record: :new_episodes) do
        start_date = (Time.now - 11.month).to_i
        end_date = Time.now.to_i
        response = importer.fetch_air_pollution_history(19.0760, 72.8777, start_date, end_date) # Coordinates for Mumbai
        expect(response).not_to be_nil
        expect(response['list'].first['main']['aqi']).to eq(3)
      end
    end
  end
end
