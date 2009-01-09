ActionController::Routing::Routes.draw do |map|
  map.resources :pages, :member => {:revert => :post, :revisions => :get}
  
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.resources :users

  map.resource :session
  map.root :controller => "pages", :action => 'show', :id => "home"
end
