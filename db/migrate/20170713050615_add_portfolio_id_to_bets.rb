class AddPortfolioIdToBets < ActiveRecord::Migration[5.1]
  def change
  	add_column :bets, :portfolio_id, :integer
  end
end
