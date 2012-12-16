require 'rake/clean'
require 'time'
require 'json'
require 'yaml'
require 'erb'

CLEAN.include 'public/'
CLEAN.include 'posts/*.json'
CLEAN.include 'posts/*.html'

task :default => :build

desc 'Build the website.'
task :build => ['public/css', 'public/images', 'public/index.html']

desc 'Start a server for testing.'
task :test do
  code = []
  code << "require 'webrick'"
  code << "o = {:Port => 8080, :DocumentRoot => 'public'}"
  code << "s = WEBrick::HTTPServer.new(o)"
  code << "trap('INT') { s.shutdown }"
  code << "s.start"
  exec "ruby -e \"#{code.join('; ')}\""
end

desc 'Install the redcarpet gem.'
task :redcarpet do
  gem_package 'redcarpet'
end

prereqs = ['posts/manifest.json']

Dir['posts/*.md'].each do |post|
  html = post.ext('.html')
  prereqs << html
  file html => [post, :redcarpet] do |t|
    sh "redcarpet --smarty #{post} > #{t.name}"
    info = post_metadata post
    @title = info['title']
    @date = info['date']
    @content = File.read t.name
    html = parse_template 'post'
    write_html t.name, html
  end
end

task :posts => prereqs do |t|
  posts = File.read 'posts/manifest.json'
  posts = JSON.parse posts
  posts.each do |post|
    @title = "#{post['title']} | Frank Mitchell"
    @content = File.read post['content']
    html = parse_template 'page'
    post = File.join('public', post['url'], 'index.html')
    write_html post, html
  end
end

file 'public/css' => Dir['css/*.*'] do |t|
  copy_folder 'css', t.name
end

file 'public/images' => Dir['images/*.*'] do |t|
  copy_folder 'images', t.name
end

file 'public/index.html' => :posts do |t|
  posts = File.read 'posts/manifest.json'
  @title = 'Frank Mitchell'
  @posts = JSON.parse posts
  @content = File.read @posts.first['content']
  @content = parse_template 'main'
  html = parse_template 'page'
  write_html t.name, html
end

file 'posts/manifest.json' => Dir['posts/*.md'] do |t|
  manifest = t.prerequisites.map do |post|
    post_metadata post
  end
  manifest.sort! { |a, b| a['timestamp'] <=> b['timestamp'] }
  manifest = JSON.pretty_generate manifest
  File.open(t.name, 'w') { |io| io << manifest }
  sh "dos2unix -U #{t.name}"
end

def post_metadata post
  yaml = []
  File.read(post).each_line do |line|
    next if line.include? '<!--'
    break if line.include? '-->'
    yaml << line.strip
  end
  info = YAML.load yaml.join("\n")
  date = Time.parse(info['date'])
  slug = File.basename(post).ext('')
  {
    'title' => info['title'],
    'content' => post.ext('.html'),
    'timestamp' => date,
    'slug' => slug,
    'url' => "/#{date.strftime("%Y/%m")}/#{slug}",
    'date' => {
      'title' => date.strftime("%-d %B %Y"),
      'abbr' => date.strftime("%-d %b.")
    }
  }
end

def write_html path, html
  dir = File.dirname(path)
  mkpath dir unless File.directory? dir
  File.open(path, 'w') { |io| io << html }
end

def parse_template name
  @templates ||= {}
  unless @templates[name]
    filename = "templates/#{name}.rhtml"
    template = File.read filename
    template = ERB.new template
    template.filename = filename
    @templates[name] = template
  end
  @templates[name].result send(:binding)
end

def copy_folder input, output
  output = File.dirname(output)
  mkpath output unless File.directory? output
  cp_r input, output
end

def gem_package name
  begin
    gem name
  rescue Gem::LoadError
    sh "gem install #{name}"
  end
end
