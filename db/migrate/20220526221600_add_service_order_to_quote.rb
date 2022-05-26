class AddServiceOrderToQuote < ActiveRecord::Migration[7.0]
  def change
    add_reference :quotes, :service_order, null: false, foreign_key: true, default: 0
    remove_reference :quotes, :package, null: false, foreign_key: true
  end
end
