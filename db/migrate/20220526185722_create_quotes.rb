class CreateQuotes < ActiveRecord::Migration[7.0]
  def change
    create_table :quotes do |t|
      t.string :quote_group
      t.references :shipping_company, null: false, foreign_key: true
      t.references :package, null: false, foreign_key: true
      t.decimal :fee
      t.integer :delivery_time
      t.boolean :is_valid

      t.timestamps
    end
  end
end
