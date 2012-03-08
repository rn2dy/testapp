Feature: Create topic
  In order to really benefit from Klipt 
  As a user
  I should be able to create topics of my insterests

  Background: 
    Given I am logged in
    
  Scenario: I creates a new topic which already exist
    Given The topic "Toyota" already exist 
    When I creates a new topic "Toyota"
    Then I should see a duplicate topic "Toyota" message

  Scenario: I creates a new topic that is unique 
    Given The topic "Toyota" does not exist
    When I creates a new topic "Toyota"
    Then I should see the topic "Toyota" appears in the page 
