class PagesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, :with => :create_missing_page
  before_filter :login_required
  
  def index
    @pages = Page.paginate(:all, :page => params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pages }
    end
  end

  def show
    @page = Page.find_by_wiki_title!(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @page }
    end
  end

  def new
    @page = Page.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @page }
    end
  end

  def edit
    @page = Page.find_by_wiki_title!(params[:id])
  end

  def create
    if logged_in?
      @page = current_user.pages.new(params[:page])
    else
      params[:page].delete(:user_id)
      @page = Page.new(params[:page])
    end
    
    respond_to do |format|
      if @page.save!
        flash[:notice] = 'Page was successfully created.'
        format.html { redirect_to(@page) }
        format.xml  { render :xml => @page, :status => :created, :location => @page }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @page = Page.find_by_wiki_title!(params[:id])
    
    respond_to do |format|
      if @page.update_attributes(params[:page].merge({:user => current_user}))
        flash[:notice] = 'Page was successfully updated.'
        format.html { redirect_to(@page) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def revert
    @page = Page.find_by_wiki_title!(params[:id])
    @page.revert_to(params[:revision])

    redirect_to @page    
  end
  
  def revisions
    @page = Page.find_by_wiki_title(params[:id])
    @revisions = @page.revisions.paginate(:per_page => 30, :page => params[:page])
  end
  
  # def destroy
  #   @page = current_user.pages.find(params[:id])
  #   @page.destroy
  # 
  #   respond_to do |format|
  #     format.html { redirect_to(pages_url) }
  #     format.xml  { head :ok }
  #   end
  # end
  
private
  def authorized?
    if not logged_in?
      return false unless Wiki.allow_anonymous_view

      [
        [['edit', 'update'], "allow_anonymous_edit"],
        [['revert'], "allow_anonymous_revert"],
        [['new', 'create'], "allow_anonymous_create"]
      ].each do |actions, permission|
        if actions.include?(action_name)
          return false unless Wiki.send(permission)
        end
      end
    else
      true
    end
  end
  
  def create_missing_page(ex)
    @page = Page.new(:title => params[:id].underscore.humanize)
    flash.now[:notice] = "That page doesn't exist.  You can create it now!"
    render :template => 'pages/new'
  end
end
