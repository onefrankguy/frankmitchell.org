require 'rake/clean'
require 'time'
require 'json'
require 'yaml'
require 'erb'
require 'cgi'

CLEAN.include 'public/'
CLEAN.include 'manifest.json'
CLEAN.include 'posts/*.html'

task :default => :build

desc 'Build the website.'
task :build => [
:redcarpet,
'public/css',
'public/images',
'public/index.html',
'public/archive/index.html',
'public/feed/atom.xml'
] do
  manifest.each { |post| Rake::Task[post['content']['page']].invoke }
end

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
  begin
    gem 'redcarpet'
  rescue Gem::LoadError
    sh 'gem install redcarpet'
  end
end

desc 'Find unused CSS selectors'
task :deadweight do
  begin
    gem 'deadweight'
  rescue Gem::LoadError
    sh 'gem install deadweight'
  end
  require 'deadweight'
  dw = Deadweight.new
  dw.stylesheets = Dir['css/*.css']
  dw.pages = Dir['public/**/*.html']
  dw.root = './'
  puts dw.run
end

Rake::Task[:clean].enhance do
  Rake::Task['manifest.json'].reenable
end

file 'manifest.json' => [Dir['posts/*.md'], __FILE__].flatten do |t|
  posts = t.prerequisites.select { |path| path.end_with? '.md' }
  posts.map! { |orig| post_metadata orig }
  posts.sort! { |a, b| b['timestamp'] <=> a['timestamp'] }
  posts = JSON.pretty_generate posts
  write_text t.name, posts
end

file 'public/css' => Dir['css/*.*'] do |t|
  copy_folder 'css', t.name
end

file 'public/images' => Dir['images/*.*'] do |t|
  copy_folder 'images', t.name
end

file 'public/feed/atom.xml' => %W[
templates/feed.rhtml
#{__FILE__}
manifest.json
] do |t|
  @entries = manifest[0...10]
  @entries.map! do |entry|
    name = entry['content']['escaped']
    Rake::Task[name].invoke
    entry['content'] = File.read name
    entry['timestamp'] = Time.parse entry['timestamp']
    entry['timestamp'] = entry['timestamp'].xmlschema
    entry
  end
  @updated = Time.parse @entries.first['timestamp']
  @updated = @updated.xmlschema
  xml = parse_template 'feed'
  write_text t.name, xml
end

file 'public/archive/index.html' => %W[
templates/page.rhtml
templates/archive.rhtml
templates/navi.rhtml
#{__FILE__}
manifest.json
] do |t|
  words = {}
  manifest.each do |post|
    year = Time.parse(post['timestamp']).year
    words[year] ||= []
    words[year] << post
  end
  @posts = words.keys.sort.reverse.map { |year| [year, words[year]] }
  @archive = parse_template 'archive'
  @content = parse_template 'navi'
  html = parse_template 'page'
  write_text t.name, html
end

file 'public/index.html' => %W[
templates/main.rhtml
templates/page.rhtml
templates/archive.rhtml
#{__FILE__}
manifest.json
] do |t|
  words = {}
  manifest[0...10].each do |post|
    year = Time.parse(post['timestamp']).year
    words[year] ||= []
    words[year] << post
  end
  @posts = words.keys.sort.reverse.map { |year| [year, words[year]] }
  @archive = parse_template 'archive'
  Rake::Task[manifest.first['content']['post']].invoke
  @title = 'Frank Mitchell'
  @content = File.read manifest.first['content']['post']
  @content = parse_template 'main'
  html = parse_template 'page'
  write_text t.name, html
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
  url = "/#{date.strftime("%Y/%m")}/#{slug}"
  {
    'title' => info['title'],
    'content' => {
      'original' => post,
      'raw' => post.ext('.raw.html'),
      'escaped' => post.ext('.escaped.html'),
      'post' => post.ext('.post.html'),
      'page' => File.join('public', url, 'index.html')
    },
    'timestamp' => date,
    'slug' => slug,
    'url' => url,
    'date' => {
      'title' => date.strftime("%-d %B %Y"),
      'abbr' => date.strftime("%-d %b."),
      'time' => date.strftime("%Y-%m-%d")
    }
  }
end

def write_text path, text
  dir = File.dirname(path)
  mkpath dir unless File.directory? dir
  File.open(path, 'w') { |io| io << text }
  sh "dos2unix -U #{path}"
end

def parse_template name
  @templates ||= {}
  unless @templates[name]
    filename = "templates/#{name}.rhtml"
    template = File.read filename
    template = ERB.new template, 0, '<>'
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

def manifest
  Rake::Task['manifest.json'].invoke
  posts = File.read 'manifest.json'
  JSON.parse posts
end

Rake::Task['public/index.html'].enhance [manifest.first['content']['post']]

manifest.each do |info|
  file info['content']['raw'] => info['content']['original'] do |t|
    sh "redcarpet --smarty #{info['content']['original']} > #{t.name}"
  end

  file info['content']['escaped'] => info['content']['raw'] do |t|
    html = File.read info['content']['raw']
    html = CGI.escape_html html
    write_text t.name, html
  end

  file info['content']['post'] => %W[
    #{info['content']['raw']}
    templates/post.rhtml
  ] do |t|
    @title = info['title']
    @date = info['date']
    @content = File.read info['content']['raw']
    html = parse_template 'post'
    write_text t.name, html
  end

  file info['content']['page'] => %W[
    #{info['content']['post']}
    templates/page.rhtml
  ] do |t|
    @title = "#{info['title']} | Frank Mitchell"
    @date = info['date']
    @content = File.read info['content']['post']
    html = parse_template 'page'
    write_text t.name, html
  end
end
