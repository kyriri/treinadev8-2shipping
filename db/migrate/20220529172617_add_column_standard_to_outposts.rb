class AddColumnStandardToOutposts < ActiveRecord::Migration[7.0]
  def change
    add_column :outposts, :standard, :boolean, default: false
  end
end
