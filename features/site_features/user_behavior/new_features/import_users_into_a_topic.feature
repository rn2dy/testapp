Feature: Import users into a topic
  In order to let a user to invite many friends at one shot
  The user
  Should be able to import a list of users

  Scenario: A user imports friends successfully to a topic
    Given A topic
    And The user is either an invitee or the owner of the topic
    And The user's friends 
    When The user imports the list of friends  
    Then The users who are not already in the topic should receive a notification
    And The users who are in the topic already should not receive a notification
    And The user should be notified that the importing is done

