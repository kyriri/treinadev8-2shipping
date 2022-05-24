class CreateDeliveryTimes < ActiveRecord::Migration[7.0]
  def change
    create_table :delivery_times do |t|
      t.integer :max_distance_in_km
      t.integer :delivery_time_in_buss_days
      t.references :shipping_company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
