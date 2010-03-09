class ActionController::Routing::RouteSet::Mapper
  def restful_catch_all_route(options={})
    id_rexp = options[:id] || /[^-\/]*-[^\/]*|\d+/
    connect '/:controller', :action => :index, :conditions => { :method => :get }
    connect '/:controller', :action => :create, :conditions => { :method => :post }
    connect '/:controller/:id', :action => :show, :conditions => { :method => :get }, :requirements => { :id => id_rexp }
    connect '/:controller/:id', :action => :update, :conditions => { :method => :put }, :requirements => { :id => id_rexp }
    connect '/:controller/:id', :action => :destroy, :conditions => { :method => :delete }, :requirements => { :id => id_rexp }
    connect '/:controller/:action' # collection
    connect '/:controller/:id/:action', :requirements => { :id => id_rexp } # member
  end
end