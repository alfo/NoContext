%w{ rubygems bundler find rake/testtask}.each { |lib| require lib }

task :default => :spec

Rake::TestTask.new(:spec) do |t|
  t.test_files = FileList['spec/*_spec.rb']
  t.ruby_opts = ['-rubygems'] if defined? Gem
end
