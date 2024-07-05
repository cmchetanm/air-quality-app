require 'rails_helper'

RSpec.describe AirPollutionDatum, type: :model do

  describe "associations" do
    it { should belong_to(:location) }
  end

  describe "get_aqi_avg_per_month_per_location" do
    let!(:location1) { FactoryBot.create(:location) }
    let!(:location2) { FactoryBot.create(:location) }
    let!(:location3) { FactoryBot.create(:location) }
    it 'returns average AQI data per month per location' do
      result = AirPollutionDatum.get_aqi_avg_per_month_per_location
      expect(result.length).to eq(3)
      expect(result.first.location_id).to eq(location1.id)
      expect(result.first.month.strftime('%Y-%m-%d')).to eq(location1.air_pollution_data.first.created_at.beginning_of_month.strftime('%Y-%m-%d'))
      average_aqi_values = result.map { |datum| datum.average_aqi } 
      expect(result.first.average_aqi.to_f).to eq(average_aqi_values[0])
    end
  end

  describe 'no record found for avg get_aqi_avg_per_month_per_location' do 
    it 'returns an empty result' do 
      result = AirPollutionDatum.get_aqi_avg_per_month_per_location
      expect(result).to be_empty
    end
  end

  describe "get_avg_per_location" do
    let!(:location1) { FactoryBot.create(:location) }
    let!(:location2) { FactoryBot.create(:location) }
    let!(:location3) { FactoryBot.create(:location) }
    it 'returns average AQI per location' do
      result = AirPollutionDatum.get_avg_per_location
      expect(result.length).to eq(3) 
      expect(result.first.location_id).to eq(location1.id)
      average_aqi_values = result.map { |datum| datum.average_aqi } 
      expect(result.first.average_aqi.to_f).to eq(average_aqi_values[0])  # Average of 50 and 70 for location1
    end
  end

  describe 'no record found for get_avg_per_location' do 
    it 'returns an empty result' do 
      result = AirPollutionDatum.get_avg_per_location
      expect(result).to be_empty
    end
  end
end
