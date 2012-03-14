# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

puts 'EMPTY THE MONGODB DATABASE'
Mongoid.master.collections.reject { |c| c.name =~ /^system/}.each(&:drop)

## create users

puts 'Setting up (20) test users'
base_names = []
File.open(File.dirname(__FILE__) + '/animals.txt') { |f| base_names = f.read.split(',') }

base_names[1..20].each do |name|
  user = User.create! :name => name.downcase, :email => "#{name.gsub(/\s+/, '_').downcase}@klipt.com", :password => 'password', :password_confirmation => 'password'
  puts 'New user created: ' << user.name
end

## create topics
puts "Setting up test topics..."

User.all.each do |user|
  (1 + rand(7)).times do
    topic_name =  "To-#{('a'..'z').to_a.shuffle[1..3].join()}-pic"
    user.topics.create(
      name: topic_name,
      starter_name: user.name,
      starter_id: user.id
     )
     puts "Generate topic: #{topic_name} for #{user.name} "
  end
end

puts "Test topics generated!"

