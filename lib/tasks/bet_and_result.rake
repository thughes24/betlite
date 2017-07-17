desc 'Resets Postgres auto-increment ID column sequences to fix duplicate ID errors'
task :reset_sequences => :environment do
  Rails.application.eager_load!

  ActiveRecord::Base.descendants.each do |model|
    unless model.attribute_names.include?('id')
      Rails.logger.debug "Not resetting #{model}, which lacks an ID column"
      next
    end

    begin
      max_id = model.maximum(:id).to_i + 1
      result = ActiveRecord::Base.connection.execute(
        "ALTER SEQUENCE #{model.table_name}_id_seq RESTART #{max_id};"
      )
      Rails.logger.info "Reset #{model} sequence to #{max_id}"
    rescue => e
      Rails.logger.error "Error resetting #{model} sequence: #{e.class.name}/#{e.message}"
    end
  end
end

################## IMPORTANT RAKE TASKS ###########################

#task :bet => :environment do
#  bets = JSON.parse(open("https://elbotto.herokuapp.com/juice/multipicks").read)
#  Bet.input_bets(bets)
#end

task :bet => :environment do
  bets = JSON.parse(open("https://elbotto.herokuapp.com/juice/multipicks").read)
  surefire = JSON.parse(open("https://elbotto.herokuapp.com/juice/surefire").read)
  Bet.input_bets(bets)
  Bet.input_bets(surefire)
end

#task :results => :environment do
#  b = Bet.do_results
#  if b.count > 0
#    last_result = Result.last
#    profit = b.map(&:profit).map(&:to_f).inject(&:+).to_f
#    points_profit = (profit/(last_result.after/200))
#    staked = b.map(&:stake).map(&:to_f).inject(&:+).to_f
#    result = Result.new(date: (Date.parse(Bet.last.created_at.to_s)), previous: last_result.after, after: (last_result.after+profit), profit: profit, points_profit: points_profit, total_staked: staked, running_profit: ((last_result.running_profit)+profit), running_points_profit: (last_result.running_points_profit+points_profit))
#    result.save
#  end
#end

task :results => :environment do
  bets = Bet.do_results
  Portfolio.all.each do |portfolio|
    last_result = portfolio.results.last
    profit = bets.reject{|f| f.portfolio_id != portfolio.id}.map(&:profit).map(&:to_f).inject(&:+).to_f
    staked = bets.reject{|f| f.portfolio_id != portfolio.id}.map(&:stake).map(&:to_f).inject(&:+).to_f
    result = Result.new(portfolio: portfolio, date: (Date.today), previous: last_result.after, after: (last_result.after+profit), profit: profit, total_staked: staked, running_profit: ((last_result.running_profit)+profit))
    portfolio.current_bankroll = (last_result.after + profit)
    result.save!
    portfolio.save!
  end
end

#####---DELETEWHENDONE------####

task :fix_one => :environment do
  bank = 5000
  Bet.all.where(portfolio_id: 1).reject{|y| y.result.blank?}.each do |x|
    x.stake = (bank*(0.03))/(x.suggested.to_f-1)
    if x.result == "WON"
      prof = (x.stake.to_f*(x.odds.to_f-1))*(0.95)
    elsif x.result == "LOST"
      prof = -(x.stake.to_f)
    else
      prof = 0
    end
    bank += prof
    x.profit = prof
    x.save
    puts bank
  end
end

task :fix_two => :environment do
  munz = 5000
  runnin = 0
  Result.all.where(portfolio_id: 1).sort.each do |result|
    m = munz
    result.previous = m
    result.save
    days_bets = Bet.all.where("DATE(created_at) = ?", Date.parse(result.date.to_s)).reject{|t|t.portfolio_id == 2}
    prof = days_bets.count > 0 ? days_bets.map(&:profit).map(&:to_f).inject(:+) : 0
    stak = days_bets.count > 0 ? days_bets.map(&:stake).map(&:to_f).inject(:+) : 0
    result.profit = prof
    result.total_staked = stak
    result.after = m + prof
    munz += prof
    r = runnin + prof
    result.running_profit = r
    runnin += prof
    result.save
  end
end





