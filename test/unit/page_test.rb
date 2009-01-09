require 'test_helper'

class PageTest < ActiveSupport::TestCase
  fixtures :users
  
  before do
    @page ||= Page.create(:title => "Fantastic Sam", :body => "is a *fun* gent.")
  end
  
  context "Creating a page" do
    context "validating" do
      it "requires a title" do
        page = Page.new(:body => 'cool')
        assert !page.valid?
        
        page.title = "Hello"
        assert page.valid?
      end
    end
    
    it "renders a wiki title" do
      assert_equal "Fantastic_Sam", @page.wiki_title
    end
    
    it "renders the body html" do
      assert_equal "<p>is a <strong>fun</strong> gent.</p>", @page.body_html
    end
    
    context "saving" do
      fixtures :users
      
      it "allows anonymous" do
        page = Page.create(:title => "Prawns are delish", :body => "is a *fun* gent.", :user_id => nil)
        
        assert page.revisions.first.message =~ /anonymous/
      end
    
      it "keeps track of the user" do
        page = Page.create(:title => "That's a fine sea bass", :body => "is a *fun* gent.", :user => users(:quentin))
                
        assert page.revisions.first.message =~ /quentin/
      end
    end
  end
  
  context "Commit messages" do
    it "creates an initial commit message" do
      assert @page.revisions.last.message =~ /initial/
    end
    
    it "creates an edit message" do
      @page.title = "hello"
      @page.save!
      
      assert @page.revisions.first.message =~ /edit/
    end
    
    it "creates a rollback message" do
      @page.title = "hello"
      @page.save!
      @page.revert_to(@page.log.last)

      assert @page.revisions.first.message =~ /rollback/
    end
  end
  
  context "Wiki titling" do
    it "removes non-alphanumeric stuff" do
      assert_equal "I_Like", "I like $".to_wiki_title
      assert_equal "What_Heh_Ha", "What!! Heh! !Ha".to_wiki_title
      assert_equal "What", "*** WHAT ***".to_wiki_title
    end
    
    it "removes spaces" do
      assert_equal "What_Is_This", "What is this".to_wiki_title
      assert_equal "This_Is_A_Lot_Of_Space", "This      is      a      lot       of       space".to_wiki_title
      assert_equal "Hello_There", " Hello There ".to_wiki_title
    end
    
    it "intellingently capitalizes" do
      assert_equal "Goodbye_World", "goodbye world".to_wiki_title
      assert_equal "This_Is_So_Great", "tHIS iS so GrEaT".to_wiki_title
      assert_equal "What_Did_You_Do", "what Did You Do".to_wiki_title
    end
  end
end
