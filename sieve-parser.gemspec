require 'rubygems'

spec = Gem::Specification.new do |s|
  s.name = 'sieve-parser'
  s.version = '0.0.6'
  s.summary = 'A Ruby library for sieve parser'
  s.description = <<-EOF
    sieve-parser is a pure-ruby implementation for parsing and 
    manipulate the sieve scripts.
  EOF
  s.add_dependency 'split-where'
  s.requirements << 'A sieve script to parse and gem ruby-managesieve to connect on server.'
  s.files = [
            'lib/sieve-parser',
            'lib/sieve-parser/action.rb',
            'lib/sieve-parser/condition.rb',
            'lib/sieve-parser/filter.rb',
            'lib/sieve-parser/filterset.rb',
            'lib/sieve-parser/vacation.rb',
            'lib/sieve-parser.rb',
            'sieve-parser.gemspec'
            ]

  s.has_rdoc = true
  s.author = 'Thiago Coutinho (www.locaweb.com.br)'
  s.email = 'thiago@osfeio.com'
  s.rubyforge_project = 'sieve-parser'
  s.homepage = "http://github.com/selialkile/sieve-parser"
end

if __FILE__ == $0
  Gem::Builder.new(spec).build
else
  spec
end
