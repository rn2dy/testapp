### UTILITY METHODS ###
def valid_user
  @user ||= { :name => "dogs", :email => "dogs@klipt.com",
    :password => "password", :password_confirmation => "password"}
end

def sign_up user
  visit '/'
  fill_in "user_email", :with => user[:email]
  fill_in "user_password", :with => user[:password]
  click_button "Get Started"
end

def sign_in user
  visit '/'
  click_link 'Login'
  fill_in "login_email", :with => user[:email]
  fill_in "login_password", :with => user[:password]
  click_button "Login"
end

### GIVEN ###
Given /^I am not logged in$/ do
  visit '/users/sign_out'
end

Given /^I am logged in$/ do
  sign_in valid_user
end

Given /^I exist as a user$/ do
  sign_up valid_user
  visit '/users/sign_out'
end

Given /^I do not exist as a user$/ do
  User.find(:first, :conditions => { :email => valid_user[:email] }).should be_nil
end

### WHEN ###
When /^I sign out$/ do
  visit '/users/sign_out'
end

When /^I sign up with valid user data$/ do
  sign_up valid_user
end

When /^I sign up with an invalid email$/ do
  user = valid_user.merge(:email => "notanemail")
  sign_up user
end

When /^I sign up without password$/ do
  user = valid_user.merge(:password => "")
  sign_up user
end

When /^I sign up with too short password$/ do
  user = valid_user.merge(:password => "123")
  sign_up user
end

When /^I sign up with same email$/ do
  user = valid_user  
  sign_up user
end

When /^I sign in with a wrong email$/ do
  user = valid_user.merge(:password => "rubbish@")
  sign_in user
end


When /^I sign in with a wrong password$/ do
  user = valid_user.merge(:password => "wrongpass")
  sign_in user
end

When /^I sign in with valid credentials$/ do
  sign_in valid_user
end

When /^I go to the home page$/ do
  visit '/' 
end

### THEN ###
Then /^I should see a login error message$/ do
  page.find('#loginForm span.error-message', 
            :message => 'Can not find error message') 
end

Then /^I should see a sign up error message$/ do |message|
  page.should have_content(message)
  page.find('#signupForm span.error-message', 
            :message => 'Can not find error message')
end

Then /^I should stay in home page$/ do
  page.current_path == '/' 
end

Then /^I should be redirected to my dashboard$/ do
  page.current_path.should == home_dashboard_path 
end

Then /^I should be redirected to home page$/ do
  page.current_path == '/'
end
