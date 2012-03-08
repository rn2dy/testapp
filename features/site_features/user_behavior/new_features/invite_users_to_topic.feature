Feature: Invite a user to a topic
  In order to let users engjoy being participating in a topic
  The users
  Should be able to invite other users to the topic

  Scenario: Invite a user to a shared topic
    Given A topic
    And The user(Bob) who is a invitee or owner of the topic
    And A user(Alice) who is not invitee or owner of the topic
    When Bob invites Alice to the topic
    Then Alice should be notified of this invitation
    And Bob should see the invitation was successfully send out

