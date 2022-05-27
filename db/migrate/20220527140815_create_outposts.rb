class CreateOutposts < ActiveRecord::Migration[7.0]
  def change
    create_table :outposts do |t|
      t.string :name
      t.string :city_state
      t.string :category
      t.references :shipping_company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
