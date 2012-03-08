Feature: Leave(Delete) topic
  In order to let the owner have the ability of walk away from a topic
  The owner 
  Should be able to leave the topic

  Scenario: A user leaves a topic successfully
    Given The topic
    And The topic belongs to the user
    When The user leaves
    Then A confirmation is presented
    When The user confirms
    Then The topic's user delete field is set to YES
    Then The topic should disappear from ??

