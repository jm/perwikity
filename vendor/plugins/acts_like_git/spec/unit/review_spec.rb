require File.dirname(__FILE__) + '/../spec_helper'

shared_examples_for "it keeps history" do
  it "should have history for content" do
    @review.history(:content).should_not be_empty
  end

  it "should have history for user_id" do
    @review.history(:user_id).should_not be_empty
  end
end

context "A Review that versions a integer field along with a string" do
  before(:each) do
    @review = Review.create!(:content => "Stuff", :user_id => 1)
  end

  it "should version content" do
    @review.git_settings.versioned_fields.should include(:content) 
  end

  it "should version user_id" do
    @review.git_settings.versioned_fields.should include(:user_id) 
  end

  it_should_behave_like "it keeps history"

  it "should allow for modifications and versioning" do
    new_version(@review)

    @review.log.size.should == 2
    @review.history(:content).size.should == 2
    @review.history(:user_id).size.should == 2
  end

  it "should get history for specific version" do
    @review.get_version(:content, @review.log.first).should == "Stuff"
    @review.get_version(:user_id, @review.log.first).should == "1"

    new_version(@review)

    @review.get_version(:content, @review.log.last).should == "Stuff"
    @review.get_version(:user_id, @review.log.last).should == "1"

    @review.get_version(:content, @review.log.first).should == "More Stuff"
    @review.get_version(:user_id, @review.log.first).should == "13"
  end

  it "should pull out the proper ID from the commits" do
    other_review = Review.create!(:content => "Other Stuff", :user_id => 2)

    @review.get_version(:content, @review.log.first).should == "Stuff"
    other_review.get_version(:content, other_review.log.first).should == "Other Stuff"
  end

  after(:each) do
    FileUtils.rm_rf('/tmp/.data')
  end
end

def new_version(review)
  review.user_id = 13
  review.content = "More Stuff"
  review.save
end


#TODO: Get this working as well.
#context "A Review with associated User model gets versioned" do
#  before(:each) do
#    @user = User.create!(:name => "Nick")
#    @review = Review.create!(:content => "Stuff", :user => @user)
#  end
#
#  it_should_behave_like "it keeps history"
#end
