# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

decioferreira = User.create(email: 'decio.ferreira@unep-wcmc.org', password: 'decioferreira', password_confirmation: 'decioferreira')
decioferreira.update_attribute(:approved, true)
decioferreira.update_attribute(:admin, true)

assessment = Assessment.create(title: 'United Kingdom National Ecosystem Assessment', short_title: 'UK NEA')