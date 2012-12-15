require 'rake/clean'

CLEAN.include 'public/'

task :default => :build

desc 'Build the website.'
task :build => :stasis do
  sh 'stasis'
end

desc 'Start a server for testing.'
task :test => :build do
  sh 'stasis -d 8080'
end

desc 'Install the stasis gem.'
task :stasis => [:redcarpet, :haml] do
  gem_package 'stasis'
end

desc 'Install the redcarpet gem.'
task :redcarpet do
  gem_package 'redcarpet'
end

desc 'Install the haml gem.'
task :haml do
  gem_package 'haml'
end

def gem_package name
  begin
    gem name
  rescue Gem::LoadError
    sh "gem install #{name}"
  end
end
