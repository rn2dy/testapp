@javascript
Feature: Sign in
  In order to get access to protected sections of the site
  A user
  Should be able to sign in gracefully

  Scenario: User is not signed up but want to sign in
    Given I do not exist as a user
    When I sign in with valid credentials
    Then I should see a login error message 

  Scenario: User signs in successfully
    Given I exist as a user
      And I am not logged in
    When I sign in with valid credentials
    Then I should be redirected to my dashboard

  Scenario: Authenticated user return to home page
    Given I exist as a user
    And I am logged in
    When I go to the home page
    Then I should be redirected to my dashboard 

  Scenario: User enters wrong email
    Given I exist as a user
    And I am not logged in
    When I sign in with a wrong email
    Then I should see a login error message 
    
  Scenario: User enters wrong password
    Given I exist as a user
    And I am not logged in
    When I sign in with a wrong password
    Then I should see a login error message 

    
