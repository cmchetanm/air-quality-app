class CreateLocations < ActiveRecord::Migration[7.1]
  def change
    create_table :locations do |t|
      t.string :city_name
      t.decimal :latitude
      t.decimal :longitude
      t.string :state

      t.timestamps
    end
  end
end
