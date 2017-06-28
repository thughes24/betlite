class BetfairWrapper
	attr_reader :client, :discount
	def initialize(username=ENV["betfair_username"], password=ENV["betfair_password"])
		@client = Betfair::Client.new("X-Application" => ENV["betfair_app_key"])
		@client.interactive_login(username, password)
		@discount = @client.get_account_funds["discountRate"]
	end


	def real_return(profit)
		real_comission = ((100.00-discount)/100.00)*5
		((profit.to_f)*((100-real_comission)/100.00)).to_s
	end

	def place_bet(market,horse,stake)
		@order = @client.place_orders({
			marketId: market,
			instructions: [{
				orderType: "MARKET_ON_CLOSE",
				selectionId: horse,
				side: "BACK",
				marketOnCloseOrder: {
					liability: "#{stake}"
		    	}
		  	}]
		})
		@order["status"] == "SUCCESS"  ? @order["instructionReports"].first["betId"] : false
	end

	def get_result(betId)
		if raw_result = client.list_cleared_orders(betStatus: "SETTLED", betIds: [betId])["clearedOrders"].first
			@bsp = raw_result["priceRequested"] == nil ? true : false
			result = {actual_odds: raw_result["priceMatched"].to_s,result: raw_result["betOutcome"], profit: raw_result["profit"].to_s, bsp_taken: @bsp, price_reduced: raw_result["priceReduced"]}
		elsif raw_result = client.list_cleared_orders(betStatus: "VOIDED", betIds: [betId])["clearedOrders"].first
			result = {actual_odds: nil,result: "SCRATCHED", profit: "0"}
		elsif raw_result = client.list_cleared_orders(betStatus: "LAPSED", betIds: [betId])["clearedOrders"].first
			result = {actual_odds: nil,result: "SCRATCHED", profit: "0"}
		else
			result = nil
		end
	end
end