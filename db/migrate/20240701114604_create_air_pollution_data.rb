class CreateAirPollutionData < ActiveRecord::Migration[7.1]
  def change
    create_table :air_pollution_data do |t|
      t.belongs_to :location
      t.float :aqi
      t.float :co
      t.float :no
      t.float :no2
      t.float :o3
      t.float :so2
      t.float :pm2_5
      t.float :pm10
      t.float :nh3
      t.datetime :dt
      
      t.timestamps
    end
  end
end
