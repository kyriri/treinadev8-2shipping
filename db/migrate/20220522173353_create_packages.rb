class CreatePackages < ActiveRecord::Migration[7.0]
  def change
    create_table :packages do |t|
      t.integer :width_in_cm
      t.integer :height_in_cm
      t.integer :length_in_cm
      t.float :volume_in_m3
      t.integer :weight_in_g
      t.integer :distance_in_km
      t.string :pickup_address
      t.string :delivery_address
      t.string :delivery_recipient_name
      t.string :delivery_recipient_phone

      t.timestamps
    end
  end
end
