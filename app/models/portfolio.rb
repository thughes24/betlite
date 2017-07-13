class Portfolio < ActiveRecord::Base
	has_many :results
	has_many :bets
end