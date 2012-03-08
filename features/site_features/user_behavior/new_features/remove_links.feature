Feature: Remove links
  In order to let users be able to change their mind
  The users
  Should be able to remove a link

  Scenario: The user removes a links successfully
    Given The user owned the link
    When The user removes the link
    Then The user should be notified 
    And The link should disappear somewhere

  Scenario: The user can not remove a link
    Given The user does not own the link
    When The user tries to find a way to remove a link
    Then The user will not be able to do that
    And The user realize how stupid he is

