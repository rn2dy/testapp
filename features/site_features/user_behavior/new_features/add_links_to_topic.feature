Feature: Add links to topic
  In order to let user do their most important job  
  A user
  Should be able to add links to a topic

    Scenario: User add a new link successfully 
      Given The topic belongs to or shared by the user
        And The link does not exists already
       When The user creates a new link
       Then The link is saved
        And The users should be notified
        And The new link should appear ??

    Scenario: User can not add a new link to a topic
      Given The topic does not belongs to the user
        And The user does not share the topic 
       When The user browse topics       
       Then The user can not add new links to those meet the precondition 
        And The user feel like to join the topic


