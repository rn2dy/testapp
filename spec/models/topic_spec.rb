require 'spec_helper'

describe Topic do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @attr = FactoryGirl.attributes_for(:topic)
    @topic = @user.topics.create(@attr.merge(starter_id: @user.id, starter_name: @user.name))
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
 
  it "should have a starter" do
    puts @topic.inspect
    @topic.starter_name.should == @user.name
  end

  ## add invitees
  it "should be able to add multiple invitees" do
    users = FactoryGirl.create_list(:user, 3)
    @topic.add_invitees(users)
    @topic.participants.count.should == 4 # plus 1 starter
  end

  ## commenting
  it "should allow participants to add comment" do
    users = FactoryGirl.create_list(:user, 3)
    @topic.add_invitees(users)
    people = @topic.participants
    people.each do |person|
      @topic.add_comment(person, "comment...").should be_valid 
    end
  end

  it "should not allow visiters to add comment" do
    visiter = FactoryGirl.create(:user)
    lambda do
      @topic.add_comment(visiter, "comment...")
    end.should raise_error
  end



end
