class Bet < ActiveRecord::Base
	belongs_to :portfolio
	validates_presence_of :betId
	validates_uniqueness_of :portfolio_id, scope: [:selectionId, :marketId], on: :create
	def self.calculate_stake(odds, portfolio_id)
		((Result.where(portfolio_id: portfolio_id).last.after*0.03)/(odds-1)).to_i
	end

	def self.return_five_percent_profit(odds)
		((Result.last.after*0.05)/(odds-1)).to_i
	end

	def self.input_bets(formatted_selections_array)
		@bf = BetfairWrapper.new()
		formatted_selections_array.each do |x|
			ActiveRecord::Base.transaction do
				portfolio = Portfolio.find(x["betId"])
				stake = calculate_stake(x["recommended_odds"].to_f,portfolio.id)
				@current_bet = Bet.new(meeting: x["meeting"].titleize, race: x["race"],selection: x["selection"].titleize, stake: stake,betId: 'placeholder', meetingId: x["meetingId"], marketId: x["marketId"],selectionId: x["selectionId"], points: x["points"], suggested: x["recommended_odds"], portfolio: portfolio)
				if @current_bet.valid?
					@bet = @bf.place_bet(x["marketId"],x["selectionId"],stake.to_i)
					if @bet["status"] == "SUCCESS"
						@current_bet.betId = @bet["instructionReports"].first["betId"]
						@current_bet.save
						puts "#{x['selection']} placed succesfully."
					else
						puts "ERROR PLACING BET, data: #{x}, raw_response: #{@bet}"
					end
				else
					puts "#{x['selection']} already placed, moving on."
				end
			end
		end
	end

	def self.pending_bets
		where(result: nil)
	end

	def self.do_results
		@bf = BetfairWrapper.new()
		@bts = pending_bets
		@bts.each do |bet|
			@bet = bet
			@result_data = @bf.get_result(bet.betId)
			bet.result = @result_data[:result]
			bet.odds = @result_data[:actual_odds]
			bet.profit = @result_data[:result] == "WON" ? @bf.real_return(@result_data[:profit]) : @result_data[:profit]
			bet.save
		end
	end
	
	def pretty_time
  		created_at.strftime("%d-%m-%y")
  	end
end