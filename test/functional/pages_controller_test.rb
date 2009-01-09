require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  fixtures :users

  before(:all) do
    @controller = PagesController.new
  end
  
  before do
    @page ||= Page.create!(:title => "Hello world", :body => "Thanks for all the fish", :user_id => 1)
  end
  
  context "With anonymous" do    
    context "viewing" do
      before do
        Wiki.allow_anonymous_view = true
      end
      
      test "should get index" do
        get :index
        assert_response :success
        assert_not_nil assigns(:pages)
      end
      
      test "should show page" do
        get :show, :id => @page.wiki_title
        assert_response :success
      end
      
      after do
        Wiki.allow_anonymous_view = false
      end
    end
    
    context "editing" do
      before do 
        Wiki.allow_anonymous_edit = true
        Wiki.allow_anonymous_view = true
      end
      
      test "should get edit" do
        get :edit, :id => @page.wiki_title
        assert_response :success
      end

      test "should update page" do
        put :update, :id => @page.wiki_title, :page => { :title => "moog" }
        assert_redirected_to page_path(assigns(:page))
        assert_equal "moog", assigns(:page).title
      end
      
      after do
        Wiki.allow_anonymous_edit = false
        Wiki.allow_anonymous_view = false
      end
    end
    
    context "creation" do
      before do
        Wiki.allow_anonymous_create = true
        Wiki.allow_anonymous_view = true
      end
      
      test "should get new" do
        get :new
        assert_response :success
      end

      test "should create page" do
        assert_difference('Page.count') do
          post :create, :page => { :title => "hello", :body => "yayyy!" }
        end

        assert_redirected_to page_path(assigns(:page))
      end
      
      after do 
        Wiki.allow_anonymous_create = false
        Wiki.allow_anonymous_view = false
      end
    end
    
    context "reverting" do
      before do
        Wiki.allow_anonymous_revert = true
        Wiki.allow_anonymous_view = true
      end
      
      test "should revert to previous version" do
        @page.title = "Yo dawg."
        @page.save!
        @page.reload
        
        post :revert, :id => @page.wiki_title, :revision => @page.log.last
        assert_equal "Hello world", assigns(:page).title
        
        assert_redirected_to page_path(assigns(:page))
      end
      
      after do
        Wiki.allow_anonymous_revert = false
        Wiki.allow_anonymous_view = false
      end
    end
  end
  
  context "Without anonymous" do
    context "viewing" do
      before do
        Wiki.allow_anonymous_view = false
      end
      
      test "should get index" do
        get :index
        assert_redirected_to new_session_path
      end
      
      test "should show page" do
        get :show, :id => @page.wiki_title
        assert_redirected_to new_session_path
      end
    end
    
    context "editing" do
      before do 
        Wiki.allow_anonymous_edit = false
      end
      
      test "should get edit" do
        get :edit, :id => @page.wiki_title
        assert_redirected_to new_session_path
      end

      test "should update page" do
        put :update, :id => @page.wiki_title, :page => { :title => "moog" }
        assert_redirected_to new_session_path
      end
    end
    
    context "creation" do
      before do
        Wiki.allow_anonymous_create = false
      end
      
      test "should get new" do
        get :new
        assert_redirected_to new_session_path
      end

      test "should create page" do
        assert_no_difference('Page.count') do
          post :create, :page => { :title => "hello", :body => "yayyy!" }
        end

        assert_redirected_to new_session_path
      end
    end
    
    context "reverting" do
      before do
        Wiki.allow_anonymous_revert = false
      end
      
      test "should revert to previous version" do
        @page.title = "Yo dawg."
        @page.save!
        @page.reload
        
        post :revert, :id => @page.wiki_title, :revision => @page.log.last
        
        assert_redirected_to new_session_path
      end
    end
  end
end
