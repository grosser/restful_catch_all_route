require 'rubygems'
gem 'actionpack', '~>2.3'
gem 'activesupport', '~>2.3'
require 'action_pack'
require 'action_controller'
begin; require 'redgreen'; rescue LoadError; end
$LOAD_PATH << 'lib'
require 'cheap_restful_routing'

ActionController::Base.logger = nil

class CheapController < ActionController::Base
end

ActionController::Routing::Routes.draw do |map|
  map.cheap_restful_routing
  map.connect ':controller/:action/:id'
end

describe 'Routing' do
  def router
    ActionController::Routing::Routes
  end

  def params_from(method, path)
    ActionController::Routing::Routes.reload if ActionController::Routing::Routes.empty?
    router.recognize_path(path, :method => method)
  end

  it "recognises index" do
    params_from(:get, "/cheap/asds/111").should == {:controller => 'cheap', :action => 'index'}
  end
end