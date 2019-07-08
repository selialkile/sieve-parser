require 'rubygems'

spec = Gem::Specification.new do |spec|
  spec.name = 'sieve-parser'
  spec.version = '1.0.0'
  spec.summary = 'A Ruby library for sieve parser'
  spec.description = <<-EOF
    sieve-parser is a pure-ruby implementation for parsing and
    manipulate the sieve script.
  EOF
  spec.requirements << 'A sieve script to parse and gem ruby-managesieve to connect on server.'
  spec.files = [
            'lib/sieve-parser',
            'lib/sieve-parser/action.rb',
            'lib/sieve-parser/condition.rb',
            'lib/sieve-parser/filter.rb',
            'lib/sieve-parser/filterset.rb',
            'lib/sieve-parser/vacation.rb',
            'lib/sieve-parser.rb',
            'sieve-parser.gemspec'
            ]

  spec.author = 'Thiago Coutinho (www.locaweb.com.br)'
  spec.email = 'thiago@osfeio.com'
  spec.rubyforge_project = 'sieve-parser'
  spec.homepage = "http://github.com/selialkile/sieve-parser"

  spec.add_runtime_dependency 'split-where'

  spec.add_development_dependency 'concurrent-ruby'
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rb-fsevent'
  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'rspec'
end

if __FILE__ == $0
  Gem::Builder.new(spec).build
else
  spec
end
