# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Result.create(date: Date.today, previous: 10000, after: 10000,profit: 0,running_profit: 0, total_staked: 0, points_profit: 0, running_points_profit: 0)