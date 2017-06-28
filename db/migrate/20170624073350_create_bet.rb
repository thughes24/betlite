class CreateBet < ActiveRecord::Migration[5.1]
  def change
    create_table :bets do |t|
    	t.string :meeting
    	t.string :race
    	t.string :selection
    	t.string :odds
        t.string :points
    	t.integer :stake
    	t.string :betId
    	t.string :meetingId
    	t.string :marketId
    	t.string :selectionId
    	t.string :result
    	t.string :profit
        t.timestamps
    end
  end
end
