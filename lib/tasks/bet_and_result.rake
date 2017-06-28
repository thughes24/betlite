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

task :bet => :environment do
  bets = JSON.parse(open("https://elbotto.herokuapp.com/juice/multipicks").read)
  Bet.input_bets(bets)
end

task :results => :environment do
  b = Bet.do_results
  if b.count > 0
    last_result = Result.last
    profit = b.map(&:profit).map(&:to_f).inject(&:+).to_f
    points_profit = (profit/(last_result.after/200))
    staked = b.map(&:stake).map(&:to_f).inject(&:+).to_f
    result = Result.new(date: (Date.parse(Bet.last.created_at.to_s)), previous: last_result.after, after: (last_result.after+profit), profit: profit, points_profit: points_profit, total_staked: staked, running_profit: ((last_result.running_profit)+profit), running_points_profit: (last_result.running_points_profit+points_profit))
    result.save
  end
end