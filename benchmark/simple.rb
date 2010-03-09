folder = '/tmp/rest'

# make app
system "rm -rf #{folder}"
system "mkdir -p #{folder}"
system "cd #{folder}/.. && rails rest"

# copy plugin
puts here = File.dirname(File.dirname(File.expand_path(__FILE__)))
system "cp -R #{here} #{folder}/vendor/plugins"

# run benchmark
system "cp #{here}/benchmark/benchmark.rake #{folder}/lib/tasks"
system "cd #{folder} && rake bench_catch_all --trace"
system "cd #{folder} && rake bench_resources --trace"