class AddColumnPackageToServiceOrder < ActiveRecord::Migration[7.0]
  def change
    add_reference :service_orders, :package, null: false, foreign_key: true
  end
end
