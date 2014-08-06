# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Default message types
if MessageType.find_by(name: 'Survey').nil?
  MessageType.create(name: 'Survey')
end

if MessageType.find_by(name: 'Scheduling').nil?
  MessageType.create(name: 'Scheduling')
end

# One user record for tests duplicate user email validation
if User.find_by(name: 'Example User').nil?
  User.create(name: "Example User", email: "user@example.com", phone: "054-4472571", password: "123456")
end



