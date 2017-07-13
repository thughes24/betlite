class RemovePointsFromResults < ActiveRecord::Migration[5.1]
  def change
  	remove_column :results, :running_points_profit
  	remove_column :results, :points_profit
  end
end
