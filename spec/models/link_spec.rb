require "spec_helper"

describe Link do

  before(:each) do
    @attr = FactoryGirl.attributes_for(:link)   
  end

  it "should create a new instance given valid attribute" do
    Link.create! @attr.merge(url: "http://google.com")
  end

  it "should not create a new instance given invalid url" do
    link = Link.new @attr
    link.should_not be_valid
  end

  it "should extract title from url sources" do
    link = Link.create! @attr.merge(url: "http://google.com") 
    link.title.should == "Google"
  end
  
  it "should be able to add image src" do
    link = Link.create! @attr.merge(url: "http://google.com", 
                             image: File.new(Rails.root + "app/assets/images/rails.png"))
    link.image.url.empty?.should == false
  end

  it "should has clicks default to 0" do
    link = Link.create! @attr.merge(url: "http://google.com")
    link.clicks.should == 0
  end

  it "should extract title from url" do
    pending "need to create a fake url"
  end

end
