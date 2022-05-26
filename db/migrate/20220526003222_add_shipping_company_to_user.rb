class AddShippingCompanyToUser < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :shipping_company, foreign_key: true
  end
end
