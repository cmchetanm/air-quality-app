# spec/models/location_spec.rb

require 'rails_helper'

RSpec.describe Location, type: :model do

  describe "get_avg_per_state" do
    let!(:location1) { FactoryBot.create(:location, state: 'State A') }
    let!(:location2) { FactoryBot.create(:location, state: 'State A') }
    let!(:location3) { FactoryBot.create(:location, state: 'State B') }
    it 'returns average AQI per state' do
      result = Location.get_avg_per_state
      expect(result.length).to eq(3)
      expect(result.first.state).to eq('State A')
      average_aqi_values = result.map { |datum| datum.average_aqi } 
      expect(result.first.average_aqi.to_f).to eq(average_aqi_values[0])
    end
  end

  describe 'no result found for get_avg_per_state' do 
    it 'return an empty result' do
      result = Location.get_avg_per_state
      expect(result).to be_empty
    end
  end

  describe "associations" do
    it { should have_many(:air_pollution_data).dependent(:destroy) }
    it { should have_many(:air_pollution_histories).dependent(:destroy) }
  end
end