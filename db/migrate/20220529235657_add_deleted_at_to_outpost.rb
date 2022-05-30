class AddDeletedAtToOutpost < ActiveRecord::Migration[7.0]
  def change
    add_column :outposts, :deleted_at, :datetime
  end
end
