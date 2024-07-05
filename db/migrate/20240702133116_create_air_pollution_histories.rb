class CreateAirPollutionHistories < ActiveRecord::Migration[7.1]
  def change
    create_table :air_pollution_histories do |t|
      t.float :aqi
      t.float :co
      t.float :no
      t.float :no2
      t.float :o3
      t.float :so2
      t.float :pm2_5
      t.float :pm10
      t.float :nh3
      t.float :lat
      t.float :lon
      t.datetime :dt
      t.belongs_to :location 
      t.timestamps
    end
  end
end
