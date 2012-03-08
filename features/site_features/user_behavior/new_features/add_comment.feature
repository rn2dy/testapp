Feature: Add comment
  In order to let users share their thoughts about a topic
  The users
  Should be able to add comments

  Scenario: The user cannot create comments 
    Given A topic
    And The user does not own the topic
    And The user was not invited for the topic either
    When The user tries to create comments
    Then The user is not able to find a way to create comments
    And The user is frustrated

  Scenario: The user creates comments successfully
    Given A topic
    And The user owned the topic or is an invitee 
    When The user creates a comment for the topic
    Then The comment should be successfully created
    And The comment should appear somewhere

