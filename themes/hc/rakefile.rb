task :default do
  code = []
  code << "require 'webrick'"
  code << "o = {:Port => 8080, :DocumentRoot => '.'}"
  code << "s = WEBrick::HTTPServer.new(o)"
  code << "trap('INT') { s.shutdown }"
  code << "s.start"
  exec "ruby -e \"#{code.join('; ')}\""
end
