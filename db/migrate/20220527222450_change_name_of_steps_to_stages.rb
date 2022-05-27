class ChangeNameOfStepsToStages < ActiveRecord::Migration[7.0]
  def change
    rename_table :steps, :stages
  end
end