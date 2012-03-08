Feature: Change notification
  In order to let user know that some topic has changed
  The user
  Should be able to get change notifications

  Scenario: A user recieves change notification 
    Given A topic 
    And The user is an invitee of the topic
    When The topic's name changed
    Then The user should recieve a change notification
    And The topic should appear to be updated somewhere
