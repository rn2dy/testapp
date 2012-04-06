def find_topic name
  @topic ||= Topic.find(:first, conditions: { name: name }) 
end

def create_topic name
  visit '/home/dashboard'
  find('.content-new-topic .new-topic-btn').click
  fill_in 'topic_name', with: name
  click_button 'Create'
end

## Given ##
Given /^PENDING/ do
  pending
end

Given /^I am in my dashboard page$/ do
  visit '/home/dashboard' 
end

Given /^I am in the "([^\"]*)" topic page$/ do |name|
  visit topic_path(find_topic name) 
end

Given /^The topic "([^\"]*)" does not exist$/ do |name|
  Topic.find(:first, conditions: { name: name }).should be_nil 
end

Given /^The topic "([^\"]*)" exists already$/ do |name|
  Topic.create name: name 
end

Given /^"([^\"]*)" are existing users$/ do |emails|
  emails = emails.split(',').map { |email| email.strip }
  emails.each do |email|
    User.create(email: email, password: "password")
  end
end

Given /^I am a member of the topic "([^\"]*)"$/ do |name|
  create_topic name   
end
Given /^I and "([^\"]*)" are members of the topic "([^\"]*)"$/ do |email, name|
  create_topic name 
  topic = find_topic name
  user = User.create(email: email, password: "password")
  topic.participants << user
  topic.save
end

## When ##
When /^I create a new topic "([^\"]*)"$/ do |name|
  find('.content-new-topic .new-topic-btn').click
  fill_in 'topic_name', with: name
  click_button 'Create'
end

When /^I create a new topic "([^\"]*)" with invitees$/ do |name, table|
  find('.content-new-topic .new-topic-btn').click
  fill_in 'topic_name', with: name
  fill_in 'invitees', with: table.raw.join(',')
  click_button 'Create'
end

When /^I leave the topic$/ do
  find_link('Leave Topic').click 
end

## Then ##
Then /^I should be redirected to "([^\"]*)" topic page$/ do |name|
  wait_until(10) do
    page.current_path.should == topic_path( find_topic name ) 
  end
end

Then /^I should see (\d+) available invitees$/ do |counts|
  find('.count-invited span').text.should == counts 
end

Then /^I should see an error message "([^\"]*)"$/ do |message|
  page.should have_content("Same topic already exist!") 
end

Then /^I should not see "([^\"]*)" topic in dashboard$/ do |name|
  page.should_not have_content(name) 
end

Then /^"([^\"]*)" should see "([^\"]*)" topic in dashboard$/ do |email, name|
  visit '/users/sign_out'  
  sign_in({ email: email, password: "password" })
  page.should have_content(name)
end

Then /^The topic "([^\"]*)"'s participants count should be (\d+)$/ do |name, counts|
  visit topic_path(find_topic name)
  find('.count-invited span').text.should == counts 
end
