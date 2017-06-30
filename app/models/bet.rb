class Bet < ActiveRecord::Base
	validates_presence_of :betId
	validates_uniqueness_of [:selectionId], on: :create
	def self.calculate_stake(points)
		(Result.last.after/200)*points
	end

	def self.input_bets(formatted_selections_array)
		@bf = BetfairWrapper.new()
		formatted_selections_array.each do |x|
			ActiveRecord::Base.transaction do
				stake = calculate_stake(x["points"].to_i)
				@current_bet = Bet.new(meeting: x["meeting"].titleize, race: x["race"],selection: x["selection"].titleize, stake: stake,betId: 'placeholder', meetingId: x["meetingId"], marketId: x["marketId"],selectionId: x["selectionId"], points: x["points"], suggested: x["recommended_odds"])
				if @current_bet.valid?
					if @bet = @bf.place_bet(x["marketId"],x["selectionId"],Bet.calculate_stake(x["points"].to_f))
						@current_bet.betId = @bet
						@current_bet.save
						puts "#{x['selection']} placed succesfully."
					else
						puts "ERROR PLACING BET, data: #{x}"
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