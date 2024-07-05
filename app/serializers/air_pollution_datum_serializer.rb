class AirPollutionDatumSerializer < ActiveModel::Serializer
  attributes :id, :aqi, :co, :no, :no2, :o3, :so2, :pm2_5, :pm10, :nh3
end

