require 'rake/clean'

CLEAN.include 'public/'

task :default => :build

desc 'Build the website.'
task :build => :statis do
  sh 'stasis'
end

desc 'Start a server for testing.'
task :test => :build do
  sh 'stasis -d 8080'
end

desc 'Install the stasis gem.'
task :statis => [:redcarpet, :haml] do
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

desc 'Install the haml gem.'
task :haml do
  begin
    gem 'haml'
  rescue Gem::LoadError
    sh 'gem install haml'
  end
end
