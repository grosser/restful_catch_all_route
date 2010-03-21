klass = if ActionPack::VERSION::MAJOR >= 3
  ActionDispatch::Routing::DeprecatedMapper
else
  ActionController::Routing::RouteSet::Mapper
end

klass.class_eval do
  def restful_catch_all_route(options={})
    id_rexp = options[:id] || /[^-\/]*-[^\/]*|\d+/
    connect '/:controller', :action => :index, :conditions => { :method => :get }
    connect '/:controller', :action => :create, :conditions => { :method => :post }
    connect '/:controller/:id', :action => :show, :conditions => { :method => :get }, :requirements => { :id => id_rexp }
    connect '/:controller/:id', :action => :update, :conditions => { :method => :put }, :requirements => { :id => id_rexp }
    connect '/:controller/:id', :action => :destroy, :conditions => { :method => :delete }, :requirements => { :id => id_rexp }
    connect '/:controller/:id/:action', :requirements => { :id => id_rexp } # member
    connect '/:controller/:action' # collection
  end
end

# if something like `unknown method 'users_path'` is raised
# convert it into :controller => :users
module ActionController::PolymorphicRoutes
  def polymorphic_url_with_restful_fallback(*args, &block)
    begin
      polymorphic_url_without_restful_fallback(*args, &block)
    rescue NoMethodError => error
      model = [*args.first] # called with [<User>] or <User>
      raise error if model.compact.size != 1 # something like [:admin, <User>], [nil,<User>], ..
      model = model.first

      options = (args.last.is_a?(Hash) ? args.last.dup : {})
      options.delete(:routing_type)

      model_name = (model.is_a?(Class) ? model : model.class).class_name.underscore

      raise error unless error.to_s =~ /\W((.*?)_)?(#{model_name}|#{model_name.pluralize})_(path|url)\W/

      options.reverse_merge!(:controller => model_name.pluralize, :action => $2)
      options.reverse_merge!(:only_path => ($4 == 'path'))
      if not model.is_a?(Class) and model.respond_to?(:new_record?) and not model.new_record?
        options.reverse_merge!(:id => model.to_param)
        options[:action] ||= :show # or it would be users?id=1 instead of users/1
      end

      url_for(options)
    end
  end
  alias_method_chain :polymorphic_url, :restful_fallback
end