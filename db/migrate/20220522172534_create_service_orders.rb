class CreateServiceOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :service_orders do |t|
      t.integer :status

      t.timestamps
    end
  end
end
