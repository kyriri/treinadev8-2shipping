class AddColumnChosenToQuotes < ActiveRecord::Migration[7.0]
  def change
    add_column :quotes, :chosen, :boolean, default: false
  end
end
