class CreateResult < ActiveRecord::Migration[5.1]
  def change
    create_table :results do |t|
    	t.date :date	
    	t.integer :previous
    	t.integer :after
    	t.integer :profit
    	t.integer :points_profit
    	t.integer :total_staked
    	t.integer :running_profit
    	t.integer :running_points_profit
    	t.timestamps
    end
  end
end
