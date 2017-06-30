class AddSuggestedToBet < ActiveRecord::Migration[5.1]
  def change
  	add_column :bets, :suggested, :string
  end
end
