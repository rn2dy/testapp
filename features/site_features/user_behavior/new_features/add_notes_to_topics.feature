Feature: Add note to topic
  In order to let user make notes about a topic
  The user
  Should be able to create note for a topic

  Scenario: A user creates a note for a topic successfully
    Given A topic
    And The user is an invitee or owner of the topic
    When The user creates a note
    Then The note should be append to the topic's notes
    And The user is happy!
