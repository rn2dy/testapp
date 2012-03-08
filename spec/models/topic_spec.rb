require 'spec_helper'

describe Topic do
  before(:each) do
    @attr = FactoryGirl.attributes_for(:topic)
  end

  it "should create a new instance given a valid attribute" do
    Topic.create! @attr
  end

  it "should require a name" do
    topic = Topic.new @attr.merge(name: "")
    topic.should_not be_valid
  end

  it "should default is_public to false" do
    topic = Topic.create! @attr
    topic.is_public.should == false
  end

  it "should belongs to an user" do
    asso = FactoryGirl.create(:user_with_owned_topics, topic_count: 1) 
    asso.owned_topics.first.should be_an_instance_of(Topic)
  end

  it "should be able to has_many invitees(user)" do
    owner = FactoryGirl.create(:topic_with_invitees, invitee_count: 3)
    owner.owned_topics[0].invitees.count.should == 3
  end

  ## commenting
  it "should allow owner or invitees to add comment" do
    owner = FactoryGirl.create(:topic_with_invitees, invitee_count: 1)  
    topic = owner.owned_topics[0]
    invitees = topic.invitees
    topic.add_comment(owner, "comment 1").should be_valid 
    topic.add_comment(invitees.first, "comment 2").should be_valid
  end

  it "should not allow visiters to add comment" do
    visiter = FactoryGirl.create(:user)
    topic = FactoryGirl.create(:user_with_owned_topics, 
                                topic_count: 1).owned_topics.first
    lambda do
      topic.add_comment(visiter, "comment 1")
    end.should raise_error
  end


end
