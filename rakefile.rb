require 'rake'

task :default => :build

desc 'Build the website.'
task :build => :statis do
  sh 'stasis'
end

desc 'Install the stasis gem.'
task :statis => :redcarpet do
  begin
    gem 'stasis'
  rescue Gem::LoadError
    sh 'gem install stasis'
  end
end

desc 'Install the redcarpet gem.'
task :redcarpet do
  begin
    gem 'redcarpet'
  rescue Gem::LoadError
    sh 'gem install redcarpet'
  end
end
