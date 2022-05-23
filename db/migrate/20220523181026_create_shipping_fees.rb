class CreateShippingFees < ActiveRecord::Migration[7.0]
  def change
    create_table :shipping_fees do |t|
      t.integer :cost_per_km_in_cents
      t.decimal :max_weight_in_kg, precision: 4, scale: 1
      t.references :shipping_company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
