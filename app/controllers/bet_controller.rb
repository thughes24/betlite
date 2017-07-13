class BetController < ApplicationController
	
	def index
	end

	def personal
		@results = Result.all.order('created_at DESC')
		@pending_bets = Bet.pending_bets
		@bets = Bet.where("created_at >= ?", Time.zone.yesterday).order('created_at ASC')
		@profit_graph_multi = @results.where(portfolio_id: 1).sort_by(&:date).map{|x| [x.date, x.running_profit]}
		@profit_graph_surefire = @results.where(portfolio_id: 2).sort_by(&:date).map{|x| [x.date, x.running_profit]}
	end
end