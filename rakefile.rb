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
'public/js/analytics.js',
'public/js/related.js',
'public/js/related.json',
'public/index.html',
'public/archive/index.html',
'public/feed/.htaccess',
'public/feed/atom.xml'
] do
  manifest.each { |post| Rake::Task[post['content']['page']].invoke }
end

desc 'Publish the website.'
task :publish do
  sh 'rsync -avz public/ frankmitchell.org:/home/public/'
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
  posts.sort! do |a, b|
    key = b['timestamp'] <=> a['timestamp']
    key = b['title'] <=> a['title'] if key == 0
    key
  end
  now = Time.now
  posts.delete_if { |post| post['timestamp'] > now }
  urls = {}
  posts.each do |info|
    url = info['url']
    raw = info['content']['original']
    abort "#{urls[url]} and #{raw} have the same URL" if urls.has_key? url
    urls[url] = raw
  end
  write_json t.name, posts
end

file 'public/js/related.js' => Dir['js/related.js'] do |t|
  copy_folder 'js/related.js', t.name
end

file 'public/js/analytics.js' => Dir['js/analytics.js'] do |t|
  copy_folder 'js/analytics.js', t.name
end

file 'public/js/related.json' => 'manifest.json' do |t|
  json = File.read 'manifest.json'
  json = JSON.parse json
  json.map! do |info|
    {
      'title' => info['title'],
      'url' => info['url'],
      'date' => info['date'],
      'tags' => info['tags'].sort.uniq
    }
  end
  write_json t.name, json
end

%w[ca css images litl recon-game].each do |name|
  file "public/#{name}" => Dir["#{name}/*.*"] do |t|
    copy_folder name, t.name
  end
  Rake::Task[:build].enhance ["public/#{name}"]
end

file 'public/feed/.htaccess' => 'templates/feed.htaccess.txt' do |t|
  copy_folder 'templates/feed.htaccess.txt', t.name
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
  @posts = archive_posts manifest
  @archive = parse_template 'archive'
  @content = parse_template 'navi'
  html = parse_template 'page'
  write_text t.name, html
end

file 'public/index.html' => %W[
templates/main.rhtml
templates/page.rhtml
#{__FILE__}
manifest.json
] do |t|
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
  date = Time.parse(info['publish'] || info['date'] || info['created'])
  slug = info['slug'] || ''
  abort "No slug found for #{post}!" if slug.empty?
  tags = info['tags'].split(',').map { |tag| tag.strip }
  url = "/#{date.strftime("%Y/%m")}/#{slug}"
  abbr = (date.strftime('%b') == 'May') ? '%-d %b' : '%-d %b.'
  data = {
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
    'tags' => tags,
    'url' => url,
    'date' => {
      'title' => date.strftime("%-d %B %Y"),
      'abbr' => date.strftime(abbr),
      'full' => date.strftime("#{abbr} %Y"),
      'time' => date.strftime("%Y-%m-%d")
    }
  }
  data['date']['full'] = nil if Time.now.year == date.year
  data
end

def archive_posts posts
  words = {}
  posts.each do |post|
    year = Time.parse(post['timestamp']).year
    words[year] ||= []
    words[year] << post
  end
  words.keys.sort.reverse.map { |year| [year, words[year]] }
end

def adjacent_posts info
  posts = manifest
  index = posts.index do |post|
    info['content']['original'] == post['content']['original']
  end
  posts[(index + 1)..(index + 5)]
end

def write_text path, text
  dir = File.dirname(path)
  mkpath dir unless File.directory? dir
  File.open(path, 'w') { |io| io << text }
  if RUBY_PLATFORM =~ /mswin/
    sh "dos2unix -U #{path}"
  else
    puts path
  end
end

def write_json path, json
  json = JSON.pretty_generate json
  write_text path, json
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

def markup_acronyms html
  @acronyms = YAML.load_file('posts/acronyms.yaml') if @acronyms.nil?
  @acronyms.each do |acronym, description|
    tag = "<abbr title=\"#{description}\">#{acronym}</abbr>"
    html.gsub! /(?!<[^<>]*?)(?<![?.\/&])\b#{acronym}\b(?!:)(?![^<>]*?>)/, tag
  end
  html
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
    html = `redcarpet --smarty #{info['content']['original']}`.strip
    html = markup_acronyms html
    write_text t.name, html
  end

  file info['content']['escaped'] => info['content']['raw'] do |t|
    html = File.read info['content']['raw']
    html = CGI.escape_html html
    write_text t.name, html
  end

  file info['content']['post'] => %W[
    #{info['content']['raw']}
    templates/post.rhtml
    templates/related.rhtml
  ] do |t|
    @url = info['url']
    @title = info['title']
    @date = info['date']
    @date['abbr'] = @date['full'] unless @date['full'].nil?
    @content = File.read info['content']['raw']
    @posts = adjacent_posts info
    @related = parse_template 'related'
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
