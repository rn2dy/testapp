@javascript
Feature: Sign up
  In order to get access to protected sections of the site
  As a user
  I want to be able to sign up

  # User does not exist before
  Scenario: User signs up with valid data
    Given I do not exist as a user
    When I sign up with valid user data
    Then I should be redirected to my dashboard
      
  Scenario: User signs up with invalid email
    Given I do not exist as a user
    When I sign up with an invalid email
    Then I should stay in home page

  Scenario: User signs up with too short password
    Given I do not exist as a user
    When I sign up with too short password
    Then I should see a sign up error message 
      """
      Password: is too short (minimum is 6 characters)
      """
      
  Scenario: User signs up without password
    Given I do not exist as a user
    When I sign up without password
    Then I should see a sign up error message 
      """
      Password: can't be blank.
      """
  # User already exist
  
  Scenario: User signs up without password
    Given I exist as a user
    When I sign up with same email
    Then I should see a sign up error message 
      """
      Email: is already taken. 
      """

