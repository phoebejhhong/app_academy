# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

ActiveRecord::Base.transaction do
  User.create(email: "mike617@gmail.com")
  User.create(email: "phoebe@gmail.com")

  TagTopic.create(name: "Music")
  TagTopic.create(name: "Social")
end
