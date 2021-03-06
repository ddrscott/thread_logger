# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'thread_logger/version'

Gem::Specification.new do |spec|
  spec.name          = 'thread_logger'
  spec.version       = ThreadLogger::VERSION
  spec.authors       = ['Scott Pierce']
  spec.email         = ['scott.pierce@centro.net']

  spec.summary       = 'Keep a history of the last X log entries automatically'
  spec.description   = ''
  spec.homepage      = 'http://stash.dev.sitescout.ad/projects/CEN/repos/jobster'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://gems.ourcentro.net"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'bcat'
  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '3.2.0'
end
