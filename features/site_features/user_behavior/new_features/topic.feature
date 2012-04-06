@javascript
Feature: Topic
  As a user
  I should be able to create/leave topics, invite friends

  Background:
    Given I exist as a user
    Given I am logged in

  Scenario: I create a new topic without invitees
    Given I am in my dashboard page
    Given The topic "Toyota" does not exist
    When I create a new topic "Toyota" 
    Then I should be redirected to "Toyota" topic page

  Scenario: I create a new topic with invitees
    Given I am in my dashboard page
    Given The topic "Toyota" does not exist
    Given "user1@example.com, user2@example.com" are existing users
    When I create a new topic "Toyota" with invitees
      | user1@example.com |
      | user2@example.com |
      | user3@example.com | 
      | user4@example.com |
   Then I should be redirected to "Toyota" topic page
   And I should see 3 available invitees

  Scenario: I create an existing topic
    Given I am in my dashboard page
    Given The topic "Toyota" exists already
    When I create a new topic "Toyota" 
    Then I should see an error message "Same topic already exist!"
 
  Scenario: I leave an existing topic with no other participants
    Given I am a member of the topic "Toyota"
    Given I am in the "Toyota" topic page 
    When I leave the topic
    Then I should be redirected to my dashboard
    And I should not see "Toyota" topic in dashboard 

  Scenario: I leave an existing topic with other participants
    Given I and "user1@example.com" are members of the topic "Toyota"
    Given I am in the "Toyota" topic page 
    When I leave the topic
    Then I should be redirected to my dashboard
    And I should not see "Toyota" topic in dashboard
    But "user1@example.com" should see "Toyota" topic in dashboard 
    And The topic "Toyota"'s participants count should be 1 

  Scenario: Unavailable user should be added to topic when available
    Given PENDING: 




