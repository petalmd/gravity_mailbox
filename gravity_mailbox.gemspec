# frozen_string_literal: true

require_relative 'lib/gravity_mailbox/version'

Gem::Specification.new do |spec|
  spec.name          = 'gravity_mailbox'
  spec.version       = GravityMailbox::VERSION
  spec.authors       = ['Jean-Francis Bastien']
  spec.email         = ['jfbastien@petalmd.com']

  spec.summary       = 'Visualize mail sent by your Rails app directly through your Rails app.'
  spec.description   = 'Development tools that aim to make it simple to visualize mail ' \
                       'sent by your Rails app directly through your Rails app.'
  spec.homepage      = 'https://github.com/petalmd/gravity_mailbox'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.6.0')

  spec.files = Dir['LICENSE.txt', 'README.md', 'lib/**/*', 'config/**/*', 'app/**/*']
  spec.extra_rdoc_files = %w[LICENSE.txt README.md]
  spec.require_paths = ['lib']

  spec.metadata = {
    'homepage_uri' => spec.homepage,
    'changelog_uri' => 'https://github.com/petalmd/gravity_mailbox/blob/main/CHANGELOG.md',
    'source_code_uri' => 'https://github.com/petalmd/gravity_mailbox',
    'bug_tracker_uri' => 'https://github.com/petalmd/gravity_mailbox/issues',
    'rubygems_mfa_required' => 'true'
  }

  spec.add_dependency 'rails', '>= 6.0'
end
