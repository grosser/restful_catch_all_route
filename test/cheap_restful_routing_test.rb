require 'rubygems'
gem 'actionpack', '~>2.3'
gem 'activesupport', '~>2.3'
require 'action_pack'
require 'action_controller'
require 'action_controller/test_process'
require 'test/unit'
begin; require 'redgreen'; rescue LoadError; end
$LOAD_PATH << 'lib'
require 'cheap_restful_routing'

ActionController::Base.logger = nil
ActionController::Routing::Routes.reload rescue nil

ActionController::Routing::Routes.draw do |map|
  map.cheap_restful_routing
end

class CheapController < ActionController::Base
  def index
    render :text => 'index'
  end
end

class SslRequirementTest < ActionController::TestCase
  def setup
    @controller = SslRequirementController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  test "it can go to index" do
    get '/cheap'
    @response.body.should == 'index'
  end
end