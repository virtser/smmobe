# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Default campaign types
if CampaignType.find_by(name: 'Survey').nil?
  CampaignType.create(name: 'Survey')
end

if CampaignType.find_by(name: 'Scheduling').nil?
  CampaignType.create(name: 'Scheduling')
end

# One user record for tests duplicate user email validation
# if User.find_by_email('tester@example.com').nil?
#  User.create(name: "Test User", email: "tester@example.com",
#              phone: "012-3456789", password: "123456")
# end



