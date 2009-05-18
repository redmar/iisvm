ActionController::Routing::Routes.draw do |map|
  map.resources :stored_images
  map.resources :rank_images

  map.root :controller => 'rank_images', :action => 'new'
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
