class CreateSteps < ActiveRecord::Migration[7.0]
  def change
    create_table :steps do |t|
      t.belongs_to :delivery
      t.belongs_to :outpost
      t.datetime :when
      t.timestamps
    end
  end
end
