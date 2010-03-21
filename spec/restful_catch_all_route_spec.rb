require 'rubygems'
gem 'actionpack', '~>2.3'
gem 'activesupport', '~>2.3'
require 'action_pack'
require 'action_controller'
begin; require 'redgreen'; rescue LoadError; end
$LOAD_PATH << 'lib'
require 'restful_catch_all_route'

ActionController::Base.logger = nil
ActionController::Routing::Routes.reload!

ActionController::Routing.use_controllers!(['cheap'])

ActionController::Routing::Routes.draw do |map|
  map.restful_catch_all_route
  map.connect ':controller/:action/:id'
end

describe 'Routing' do
  def router
    ActionController::Routing::Routes
  end

  describe 'recognition' do
    def params_from(method, path)
      ActionController::Routing::Routes.reload if ActionController::Routing::Routes.empty?
      router.recognize_path(path, :method => method)
    end

    it "recognizes index" do
      params_from(:get, "/cheap").should == {:controller => 'cheap', :action => 'index'}
    end

    it "recognizes create" do
      params_from(:post, "/cheap").should == {:controller => 'cheap', :action => 'create'}
    end

    it "recognizes show" do
      params_from(:get, "/cheap/1").should == {:controller => 'cheap', :action => 'show', :id => '1'}
    end

    it "recognizes update" do
      params_from(:put, "/cheap/1").should == {:controller => 'cheap', :action => 'update', :id => '1'}
    end

    it "recognizes destroy" do
      params_from(:delete, "/cheap/1").should == {:controller => 'cheap', :action => 'destroy', :id => '1'}
    end

    it "recognizes members" do
      params_from(:get, "/cheap/1/xxx").should == {:controller => 'cheap', :action => 'xxx', :id => '1'}
    end

    it "recognizes collections" do
      params_from(:get, "/cheap/xxx").should == {:controller => 'cheap', :action => 'xxx'}
    end

    it "recognizes to_param urls with number-text-text" do
      params_from(:get, "/cheap/111-abc-def/xxx").should == {:controller => 'cheap', :action => 'xxx', :id => '111-abc-def'}
    end

    it "recognizes to_param urls with text-text" do
      params_from(:get, "/cheap/abc-def/xxx").should == {:controller => 'cheap', :action => 'xxx', :id => 'abc-def'}
    end

    it "does not recognizes to_param urls with simple text" do
      params_from(:get, "/cheap/abc/xxx").should == {:controller => 'cheap', :action => 'abc', :id => 'xxx'}
    end

    it "does not recognizes to_param urls with method-name like names" do
      params_from(:get, "/cheap/step1/xxx").should == {:controller => 'cheap', :action => 'step1', :id => 'xxx'}
    end

    it "leaves room for old catch-all rule" do
      params_from(:get, "/cheap/xxx/111").should == {:controller => 'cheap', :action => 'xxx', :id => '111'}
    end
  end

  describe 'generation' do
    def generate(options)
      ActionController::Routing::Routes.reload if ActionController::Routing::Routes.empty?
      router.generate(options)
    end

    it "generates index without action" do
      generate(:controller => :cheap).should == "/cheap"
    end

    it "generates index with action" do
      generate(:controller => :cheap, :action => :index).should == "/cheap"
    end

    it "generates collection actions" do
      generate(:controller => :cheap, :action => :foo).should == "/cheap/foo"
    end

    it "generates show" do
      pending 'works, but not in tests.. :P'
      generate(:controller => :cheap, :id => '1').should == "/cheap/1"
    end

    it "generates show with action" do
      pending 'works, but not in tests.. :P'
      generate(:controller => :cheap, :id => '1', :action => :show).should == "/cheap/1"
    end

    it "generates member actions" do
      pending 'works, but not in tests.. :P'
      generate(:controller => :cheap, :id => '1', :action => :edit).should == "/cheap/1/edit"
    end
  end
end