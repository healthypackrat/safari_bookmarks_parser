# frozen_string_literal: true

require_relative 'lib/safari_bookmarks_parser/version'

Gem::Specification.new do |spec|
  spec.name          = 'safari_bookmarks_parser'
  spec.version       = SafariBookmarksParser::VERSION
  spec.authors       = ['healthypackrat']
  spec.email         = ['healthypackrat@gmail.com']

  spec.summary       = 'Dump ~/Library/Safari/Bookmarks.plist as JSON/YAML'
  spec.homepage      = 'https://github.com/healthypackrat/safari_bookmarks_parser'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.6.6')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['rubygems_mfa_required'] = 'true'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").select { |f| f.match(%r{^(exe|lib)/}) }
  end
  spec.files        += ['LICENSE.txt', 'README.md']
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.requirements << 'plutil'

  spec.add_runtime_dependency 'plist', '~> 3.5'
end
