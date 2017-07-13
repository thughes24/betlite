class CreatePortfolioTable < ActiveRecord::Migration[5.1]
  def change
    create_table :portfolios do |t|
		t.string :name
		t.integer :initial_bankroll
		t.integer :current_bankroll
		t.string :description
    	t.timestamps
    end
  end
end
