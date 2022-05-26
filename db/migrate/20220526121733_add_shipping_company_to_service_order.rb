class AddShippingCompanyToServiceOrder < ActiveRecord::Migration[7.0]
  def change
    add_reference :service_orders, :shipping_company, foreign_key: true
  end
end
