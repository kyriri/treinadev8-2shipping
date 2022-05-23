class AddColumnsToShippingCompany < ActiveRecord::Migration[7.0]
  def change
    add_column :shipping_companies, :cubic_weight_const, :decimal, precision: 6, scale: 2
    add_column :shipping_companies, :min_fee, :decimal, precision: 5, scale: 2
  end
end
