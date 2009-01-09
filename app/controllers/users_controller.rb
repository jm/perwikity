class UsersController < ApplicationController
  before_filter :check_logged_in, :only => [:new, :create]
  
  def new
    @user = User.new
  end
 
  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    success = @user && @user.save
    if success && @user.errors.empty?
            # Protects against session fixation attacks, causes request forgery
      # protection if visitor resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset session
      self.current_user = @user # !! now logged in
      redirect_back_or_default('/')
      flash[:notice] = "<strong>Thanks for signing up!</strong>  You're now logged in."
    else
      flash[:error]  = "<strong>We couldn't set up that account, sorry.</strong>  Please try again, or contact an admin (link is above)."
      render :action => 'new'
    end
  end
  
  def edit
    @user = current_user
  end
  
  def update
    @user = current_user
    
    respond_to do |format|
      if current_user.update_attributes(params[:user])
        flash[:notice] = "<strong>Your account details have been updated.</strong>  If you changed your password, please remember it!"
        format.html { redirect_to edit_user_path(current_user) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
end
