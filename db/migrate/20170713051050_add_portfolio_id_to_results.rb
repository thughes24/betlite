class AddPortfolioIdToResults < ActiveRecord::Migration[5.1]
  def change
  	add_column :results, :portfolio_id, :integer
  end
end
