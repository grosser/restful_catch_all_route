klass = if ActionPack::VERSION::MAJOR >= 3
  ActionDispatch::Routing::DeprecatedMapper
else
  ActionController::Routing::RouteSet::Mapper
end

klass.class_eval do
  def restful_catch_all_route(options={})
    id_rexp = options[:id] || /[^-\/]*-[^\/]*|\d+/
    id_rexp = /.*/ if id_rexp == // # we need match data!
    req = {:requirements => { :id => id_rexp }}

    connect '/:controller', :action => :index, :conditions => { :method => :get }
    connect '/:controller', :action => :create, :conditions => { :method => :post }
    connect '/:controller/:id', req.merge(:action => :show, :conditions => { :method => :get })
    connect '/:controller/:id', req.merge(:action => :update, :conditions => { :method => :put })
    connect '/:controller/:id', req.merge(:action => :destroy, :conditions => { :method => :delete })
    connect '/:controller/:id/:action', req # member
    connect '/:controller/:action' # collection
  end
end


# for Rails3 mapper, does not seem to work with namespaces yet,
# use map.restful_catch_all_route !!
if defined?(ActionDispatch::Routing::Mapper)
  class ActionDispatch::Routing::Mapper
    def restful_catch_all_route(options={})
      id_rexp = options[:id] || /[^-\/]*-[^\/]*|\d+/
      id_rexp = /.*/ if id_rexp == // # we need match data
      req = {:constraints => { :id => id_rexp}}

      match ':controller/:id', {:to  => ":controller#show", :via => :get}.merge(req)
      match ':controller/:id', {:to  => ":controller#update", :via => :put}.merge(req)
      match ':controller/:id', {:to  => ":controller#destroy", :via => :delete}.merge(req)
      match ':controller', :to => ":controller#index", :via => :get
      match ':controller', :to => ":controller#create", :via => :post
      match ':controller/:id/:action', req # any member
      match ':controller/:action' # any collection
    end
  end
end


# if something like `unknown method 'users_path'` is raised
# convert it into :controller => :users
module ActionController::PolymorphicRoutes
  def polymorphic_url_with_restful_fallback(*args, &block)
    begin
      polymorphic_url_without_restful_fallback(*args, &block)
    rescue NoMethodError => error
      # prepare and cleanup models
      models = [*args.first] # called with [<User>] or <User>
      namespaces, models = models.partition{|x| x.is_a?(String) or x.is_a?(Symbol) }
      raise error if models.size != 1
      model = models.first

      # prepare and cleanup options
      options = (args.last.is_a?(Hash) ? args.last.dup : {})
      options.delete(:routing_type)

      # match action+controller+path/url from missing method
      model_name = (model.is_a?(Class) ? model : model.class).name.underscore
      raise error unless error.to_s =~ /\W((\w+?)_)?(#{model_name}|#{model_name.pluralize})_(path|url)\W/
      options.reverse_merge!(:only_path => ($4 == 'path'))

      # add namespace to controller
      action = $2
      namespaces.each{|n| action.sub!(/^#{n}(_|$)/,'')} # remove namespaces from action
      action = nil if action.blank? # can be empty after namespace removal <-> '?action='
      controller = ((namespaces+[nil]) * '/') + model_name.pluralize # add name/space/to/controller
      options.reverse_merge!(:controller => controller, :action => action)

      # add :id when we have a model
      if not model.is_a?(Class) and model.respond_to?(:new_record?) and not model.new_record?
        options.reverse_merge!(:id => model.to_param)
        options[:action] ||= :show # or it would be users?id=1 instead of users/1
      end

      # generate the url or path
      url_for(options)
    end
  end
  alias_method_chain :polymorphic_url, :restful_fallback
end