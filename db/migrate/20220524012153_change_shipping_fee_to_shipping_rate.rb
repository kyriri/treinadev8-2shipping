class ChangeShippingFeeToShippingRate < ActiveRecord::Migration[7.0]
  def change
    rename_table :shipping_fees, :shipping_rates
  end
end
