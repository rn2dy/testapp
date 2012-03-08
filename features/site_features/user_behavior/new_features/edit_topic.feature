Feature: Edit topic
  In order to allow user to change their mind
  A user
  Should be able to edit topics

    Scenario: Edit topic failed
      Given The same name exists for the user
      Then Notify the user of this situation
      And Let user try again

    Scenario: Edit topic successed
      Given The topic name does not exist before for the user
      Then Notify the user of success
      And The new topic name replaced the old one
      And The new topic appears ??
