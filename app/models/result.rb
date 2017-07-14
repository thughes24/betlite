class Result < ActiveRecord::Base
	belongs_to :portfolio
	
	def pot
		if total_staked != 0
			((profit.to_f)/(total_staked.to_f)).round(2)
		else
			0
		end
	end

	def self.bankroll(portfolio)
		where(portfolio: portfolio).last.after
	end

	def self.days_running(portfolio)
		where(portfolio: portfolio).all.count-1
	end

	def self.pot(portfolio)
		(lifetime_profit(portfolio)/lifetime_staked(portfolio)).round(2)
	end

	def self.lifetime_staked(portfolio)
		where(portfolio: portfolio).map(&:total_staked).map(&:to_f).inject(:+)
	end

	def self.lifetime_profit(portfolio)
		where(portfolio: portfolio).map(&:profit).map(&:to_f).inject(:+)
	end

	def self.lifetime_profit_suggested(portfolio)
		prof = []
		loss = []
		Bet.all.where(portfolio: portfolio).reject{|x| x.result.blank?}.map do |x|
			if x.result == "WON"
				prof << (x.points.to_f*(x.suggested.to_f-1))*0.95
			elsif x.result == "LOST"
				loss << (x.points)
			end
		end
		(prof.map(&:to_f).inject(:+)-loss.map(&:to_f).inject(:+)).round(0)
	end
end