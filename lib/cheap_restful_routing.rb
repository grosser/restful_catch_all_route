class ActionController::Routing::RouteSet::Mapper
  def cheap_restful_routing(options={})
    connect ':controller/:id/:action', options.merge(:action => :show)
    connect ':controller/:id', :action => :show, :conditions => { :method => :get }
    connect ':controller/:id', :action => :update, :conditions => { :method => :put }
    connect ':controller/:id', :action => :destroy, :conditions => { :method => :delete }
    connect ':controller', :action => :index, :conditions => { :method => :get }
    connect ':controller', :action => :create, :conditions => { :method => :post }
    connect ':controller/:action/:id'
  end
end