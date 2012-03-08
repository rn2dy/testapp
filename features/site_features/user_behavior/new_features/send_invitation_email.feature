Feature: Send invitation email
  In order to let users recives invitation email
  The users
  Should be able to recive invitation emails

  Scenario: The invitation email is recieved successfully
    Given A topic
    And A user who is an invitee or owner of the topic
    And Some users 
    When The user send invitations to other users     
    Then The users who are not already in the topic should recieve invitation emails
    And The users who are already in the topic should not recieve invitation emails
