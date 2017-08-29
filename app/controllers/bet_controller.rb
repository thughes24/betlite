class BetController < ApplicationController
	skip_before_action :verify_authenticity_token, only: [:place]
	def index
	end

	def personal
		@surefire = Portfolio.last
		@premium = Portfolio.first
		@results = Result.all.order('date DESC')
		@pending_bets = Bet.pending_bets
		@bets = Bet.where("DATE(created_at) = ?", Date.parse(Time.new.gmtime.to_s)-1)
		@profit_graph_multi = @results.where(portfolio_id: 1).sort_by(&:date).map{|x| [x.date, x.running_profit]}
		@profit_graph_surefire = @results.where(portfolio_id: 2).sort_by(&:date).map{|x| [x.date, x.running_profit]}
	end

	def fart
		b = BetfairWrapper.new
		puts b
		head 200
	end

	def place
  		bets = JSON.parse(open("https://elbotto.herokuapp.com/juice/multipicks").read)
  		surefire = JSON.parse(open("https://elbotto.herokuapp.com/juice/surefire").read)
  		Bet.input_bets(bets)
  		Bet.input_bets(surefire)
 		head 200
	end
end