class BetController < ApplicationController
	
	def index
		@results = Result.all.order('created_at DESC')
		@bets = Bet.all
	end

	
end