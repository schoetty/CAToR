ActionController::Routing::Routes.draw do |map|
  map.resources :sessions
  map.resources :categories
  map.resources :items
  map.resources :users
  map.resources :exam_allocations
  map.resources :exams

  map.home '', :controller => 'sessions', :action => 'welcome'
  map.login 'login', :controller => 'sessions', :action => 'new'
  map.logout 'logout', :controller => 'sessions', :action => 'destroy'
  map.exam_list 'exam_list', :controller => 'exam_allocations', :action => 'list'
  map.proceed 'proceed', :controller => 'exams', :action => 'proceed'
  map.conclusion 'conclusion', :controller => 'exams', :action => 'conclusion'
  map.error 'error', :controller => 'exams', :action => 'error'
  map.root :controller => 'sessions', :action => 'new'

  map.connect ':controller/:action/:id'
#  map.connect ':controller/:action/:id.:format'
end
