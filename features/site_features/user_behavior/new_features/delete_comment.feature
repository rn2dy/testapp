Feature: Delete comment
  In order to let users change their mind
  The users
  Should be able to delete his/her comment

  Scenario: The user cannot delete a comment
    Given A comment
    And The comment does not belongs to the user
    When The user tries to delete
    Then The user is not able to do that
    And The user realized that how stupid he is

  Scenario: The user delete a comment successfully
    Given A comment
    And The comment belongs to the user
    When The user deletes the comment
    Then The comment should be deleted
    And The comment should disappear somewhere


