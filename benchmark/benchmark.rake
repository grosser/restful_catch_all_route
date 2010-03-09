TEST_CONTROLLERS = ('aa'..'bz').to_a # 52 controllers

def router
  ActionController::Routing::Routes
end

def memory
  pid = Process.pid
  map = `pmap -d #{pid}`
  map.split("\n").last.strip.squeeze(' ').split(' ')[3].to_i
end

def run_bench
  num = 100_000

  TEST_CONTROLLERS.each{|c| send("#{c}_url")}

  x = Benchmark.realtime do
    num.times do
      router.recognize_path("/#{TEST_CONTROLLERS.rand}/123/test", :method => :get)
    end
  end
  puts "Recognition: #{x}"

  x = Benchmark.realtime do
    num.times do
      # get one of the middle controllers for an even benchmark
      generated_path, extra_keys = router.generate_extras({:controller => TEST_CONTROLLERS.rand, :action => :test, :id => '123'}, {})
    end
  end
  puts "Generation: #{x}"
  puts "Memory: #{memory}"
end

task :bench_catch_all => :environment do
  ActionController::Routing.use_controllers!(TEST_CONTROLLERS)
  router.draw do |map|
    map.restful_catch_all_route
    map.connect ':controller/:action/:id'
  end

  run_bench
end

task :bench_resources => :environment do
  ActionController::Routing.use_controllers!(TEST_CONTROLLERS)

  router.draw do |map|
    # resource with some members to emulate normal usage
    TEST_CONTROLLERS.each{|c| map.resources c, :member => {:test => :get, :something => :post}, :collection => {:xxx => :get, :yyy => :get}}
    map.connect ':controller/:action/:id'
  end

  run_bench
end