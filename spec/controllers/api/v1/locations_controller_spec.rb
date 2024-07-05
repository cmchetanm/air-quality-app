require 'rails_helper'

RSpec.describe Api::V1::LocationsController, type: :controller do
  let(:params) { { city_name: city_name, country_code: country_code } }

  describe 'GET #index' do
    it 'returns all locations' do
      FactoryBot.create_list(:location, 2)  
      get :index
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).count).to eq(2)
    end

    it 'returns not found if no locations' do
      get :index
      expect(response).to have_http_status(:not_found)
      expect(json['message']).to eq("No locations found")
    end
  end

  describe 'GET #fetch_air_pollution' do

    context 'when location doen not exists' do
      it 'returns air pollution data' do
        VCR.use_cassette('fetch_current_air_pollution', record: :new_episodes) do 
          get :fetch_air_pollution, params: { city_name: 'London', country_code: 'GB'}
          expect(response).to have_http_status(:ok)
          expect(json['air_pollution_data'][0]['aqi']).to eq(2.0)
          expect(json['air_pollution_data'][0]['co']).to eq(156.88)
        end
      end

      it 'raise StandardError' do
        VCR.use_cassette('fetch_current_air_pollution', record: :new_episodes) do 
          get :fetch_air_pollution, params: { city_name: 'abc', country_code: 'df'}
          expect(response).to have_http_status(:internal_server_error)
          expect(json['message']).to eq("Unknown Failure")
        end
      end

      it 'raise RecordNotFoundError' do
        location = FactoryBot.create(:location, city_name: 'london')
        location.air_pollution_data.destroy_all
        get :fetch_air_pollution, params: { city_name: 'London', country_code: 'GB'}
        expect(response).to have_http_status(:not_found)
        expect(json['message']).to eq("No data found")
      end
    end

    context 'when either city_name or country_code not present' do
      it 'raises ArgumentError' do
        get :fetch_air_pollution, params: { city_name: 'Indore'}
        expect(response).to have_http_status(:bad_request)
        expect(json['message']).to eq("Argument Missing either city name or country code")
      end
    end

    context 'when location does exist' do
      let!(:location) { FactoryBot.create(:location) } 
      
      it 'fetches data from OpenWeatherMap' do
        get :fetch_air_pollution, params: { city_name: location.city_name, country_code: 'IN' }
        expect(response).to have_http_status(:ok)
        expect(json['air_pollution_data'][0]['aqi']).to eq(location.air_pollution_data.last.aqi)
        expect(json['air_pollution_data'][0]['co']).to eq(location.air_pollution_data.last.co)
      end
    end
  end

  describe 'GET #avg_aqi_per_month_and_location' do
    let!(:location) { FactoryBot.create(:location) } 

    it 'returns average AQI per month and location' do
      data = [
        {
          "location_id" => 138,
          "month" => "2024-07-01T00:00:00.000Z",
          "average_aqi" => "2.0"
        },
        {
          "location_id" => 139,
          "month" => "2024-07-01T00:00:00.000Z",
          "average_aqi" => "2.0"
        }
      ]

      allow(AirPollutionDatum).to receive(:get_aqi_avg_per_month_per_location).and_return(data)
      get :avg_aqi_per_month_and_location
      expect(response).to have_http_status(:ok)
      expect(json.count).to eq(2)
    end

    it 'if locations not found' do 
      location.destroy
      get :avg_aqi_per_month_and_location
      expect(response).to have_http_status(:not_found)
      expect(json['message']).to eq("No locations found")
    end 
  end
  


  describe 'GET #average_aqi_per_location' do
    let!(:location) { FactoryBot.create(:location) } 

    it 'returns average AQI per location' do
      data = [
        {
            "location_id": 138,
            "average_aqi": "2.0",
        },
        {
            "location_id": 139,
            "average_aqi": "3.5",
        }
      ]
      allow(AirPollutionDatum).to receive(:get_avg_per_location).and_return(data)
      get :average_aqi_per_location
      expect(response).to have_http_status(:ok)
      expect(json.count).to eq(2)
    end
  end

  describe 'GET #average_aqi_per_state' do
    let!(:location) { FactoryBot.create(:location) } 

    it 'returns average AQI per state' do
      data = [
        {
            "state": "Andhra Pradesh",
            "average_aqi": "2.0",
        },
        {
            "state": "Bihar",
            "average_aqi": "2.5",
        }
      ]
      allow(Location).to receive(:get_avg_per_state).and_return(data)
      get :average_aqi_per_state
      expect(response).to have_http_status(:ok)
      expect(json.count).to eq(2)
    end
  end
end



