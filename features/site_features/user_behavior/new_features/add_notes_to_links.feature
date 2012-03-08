Feature: Add notes to a link
  In order to let users make notes about a link
  The users
  Should be able to create notes for a link

  Scenario: A user creates notes successfully
    Given A topic
    And A link for the topic
    And The user is an invitee or owner of the topic
    When The user creates note for the link
    Then The note should be created successfully
    And The new note should be append to the link's notes field

