class LocationSerializer < ActiveModel::Serializer
  attributes :id, :city_name, :latitude, :longitude

  has_many :air_pollution_data, each_serializer: AirPollutionDatumSerializer

end
