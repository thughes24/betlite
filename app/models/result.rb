class Result < ActiveRecord::Base
	belongs_to :portfolio
	def pot
		if total_staked != 0
			((profit.to_f)/(total_staked.to_f)).round(2)
		else
			0
		end
	end

	def self.bankroll
		last.after
	end

	def self.days_running
		all.count-1
	end

	def self.pot
		(lifetime_profit/lifetime_staked).round(2)
	end

	def self.lifetime_staked
		all.map(&:total_staked).map(&:to_f).inject(:+)
	end

	def self.lifetime_staked_points
		all.map{|x| x.total_staked/(x.previous/200)}.map(&:to_f).inject(:+)
	end

	def self.lifetime_profit
		all.map(&:profit).map(&:to_f).inject(:+)
	end

	def self.lifetime_points_profit
		prof = []
		loss = []
		Bet.all.reject{|x| x.result.blank?}.map do |x|
			if x.result == "WON"
				prof << (x.points.to_f*(x.odds.to_f-1))*0.95
			elsif x.result == "LOST"
				loss << (x.points)
			end
		end
		(prof.map(&:to_f).inject(:+)-loss.map(&:to_f).inject(:+)).round(0)
	end

	def self.lifetime_profit_suggested
		prof = []
		loss = []
		Bet.all.reject{|x| x.result.blank?}.map do |x|
			if x.result == "WON"
				prof << (x.points.to_f*(x.suggested.to_f-1))*0.95
			elsif x.result == "LOST"
				loss << (x.points)
			end
		end
		(prof.map(&:to_f).inject(:+)-loss.map(&:to_f).inject(:+)).round(0)
	end

	def total_points_staked
		total_staked/(previous/200).round(0)
	end
end