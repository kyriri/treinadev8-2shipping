class CreateDeliveries < ActiveRecord::Migration[7.0]
  def change
    create_table :deliveries do |t|
      t.references :service_order, null: false, foreign_key: true
      t.string :tracking_code

      t.timestamps
    end
  end
end
