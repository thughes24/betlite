# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Result.create(portfolio_id: 2, date: Date.today, previous: 5000, after: 5000,profit: 0,running_profit: 0, total_staked: 0, points_profit: 0, running_points_profit: 0)
Portfolio.create(name: "Premium Picks", initial_bankroll: 5000, current_bankroll: 5000, description: "Premium Selections, low volume service with an average of around 3 bets per day.")
Portfolio.create(name: "Surefire Picks", initial_bankroll: 5000, current_bankroll: 5000, description: "Value Picks with a high strike rate, average of 3-6 bets per day.")