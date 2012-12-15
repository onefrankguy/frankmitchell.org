Stasis::Options.set_template_option 'haml', {
  :attr_wrapper => '"'
}

ignore /\.git/
ignore /layouts\//
ignore 'rakefile.rb'
ignore 'README.md'

layout 'layouts/page.haml'

before 'index.haml.html' do
  @title = 'Frank Mitchell'
end
