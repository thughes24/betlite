class BetController < ApplicationController
	
	def index
		@results = Result.all.order('created_at DESC')
		@all_bets = Bet.all
		@bets = Bet.where("created_at >= ?", Time.zone.yesterday).order('created_at DESC')
		@points_graph = @results.sort_by(&:date).map{|x| [x.date, x.running_points_profit]}
	end

	def personal
		@results = Result.all.order('created_at DESC')
		@bets = Bet.where("created_at >= ?", Time.zone.yesterday).order('created_at DESC')
		@points_graph = @results.sort_by(&:date).map{|x| [x.date, x.running_points_profit]}
		@profit_graph = @results.sort_by(&:date).map{|x| [x.date, x.running_profit]}
	end
	
end