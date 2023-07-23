# coding: us-ascii

lib_name = 'module-dbc'.freeze

Gem::Specification.new do |gem|
  # specific

  gem.description   = %q{An imitation of DbC(Design By Contract) in Ruby.}

  gem.summary       = gem.description.dup
  gem.homepage      = "https://github.com/kachick/#{lib_name}"
  gem.license       = 'MIT'
  gem.name          = lib_name.dup
  gem.version       = '0.0.4'

  gem.required_ruby_version = '>= 3.1'

  gem.add_runtime_dependency 'optionalargument'

  # common

  gem.authors       = ['Kenichi Kamiya']
  gem.email         = ['kachick1+ruby@gmail.com']
  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']
end
