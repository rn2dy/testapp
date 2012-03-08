Feature: Remove users
  In order to let a owner of a topic be selective
  The owner
  Should be able to remove an invitee

  Scenario: The owner removes a user successfully 
    Given A topic
    And The owner of the topic
    And A user who is an invitee of that topic
    When The owner removes the user
    Then The user should be removed from the topic
    And The user is notified of his unfortunate 
    And The owner should see the user is dropped from the topic's invitees

