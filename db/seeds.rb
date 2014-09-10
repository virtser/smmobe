# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Default campaign types

if CampaignType.find_by(name: 'Marketing').nil?
  CampaignType.create(name: 'Marketing')
end

if CampaignType.find_by(name: 'Events').nil?
  CampaignType.create(name: 'Events')
end

if CampaignType.find_by(name: 'Surveys').nil?
  CampaignType.create(name: 'Surveys')
end

if CampaignType.find_by(name: 'Scheduling').nil?
  CampaignType.create(name: 'Scheduling')
end


# Default campaign statuses
if CampaignStatus.find_by(name: 'Pending').nil?
  CampaignStatus.create(name: 'Pending')
end

if CampaignStatus.find_by(name: 'Running').nil?
  CampaignStatus.create(name: 'Running')
end

if CampaignStatus.find_by(name: 'Finished').nil?
  CampaignStatus.create(name: 'Finished')
end

# One user record for tests duplicate user email validation
# if User.find_by_email('tester@example.com').nil?
#  User.create(name: "Test User", email: "tester@example.com",
#              phone: "012-3456789", password: "123456")
# end



