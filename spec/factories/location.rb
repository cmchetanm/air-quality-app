FactoryBot.define do
  factory :location do
    city_name { "mumbai" }
    latitude { 12.34 }
    longitude { 56.78 }
    state { 'Madhya Pradesh' }
  end

  after(:create) do |location|
     location.air_pollution_data.create(
      aqi: 2.0, 
      pm2_5: 10.5, 
      pm10: 20.3, 
      o3: 30.1, 
      no2: 15.2, 
      so2: 5.6, 
      co: 0.8, 
      no: 1.23, 
      nh3: 1.74
    )     
  end
end
