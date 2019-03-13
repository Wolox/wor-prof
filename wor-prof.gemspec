require File.expand_path("../lib/wprof/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = 'wor-prof'
  s.version     = Wprof::VERSION
  s.date        = '2019-03-11'
  s.summary     = 'Wor-Profiling Gem for Rails'
  s.description = 'Make Description later'
  s.authors     = ['mcolombo87']
  s.author      = 'Maximiliano Colombo'
  s.email       = ['maximiliano.colombo@wolox.com.ar', 'mcolombo87@gmail.com']
  s.require_paths = ['lib']
  s.files       = ['lib/wor-prof.rb',
    'lib/wprof/wprof_modules.rb', 'lib/wprof/wprof_subscriptors.rb', 'lib/wprof/wprof_reporter.rb', 'lib/wprof/gen_prof.rb', 'lib/wprof/conf_wprof.rb', 'lib/wprof/version.rb',
    'lib/generators/wprof_generator.rb', 'lib/generators/wprof_model_generator.rb',
    'lib/wprof/reporters/db_report.rb', 'lib/wprof/reporters/external_report.rb', 'lib/wprof/reporters/file_report.rb']
  s.homepage    =
    'http://rubygems.org/gems/wor-prof'
  s.license = 'MIT'
  s.extra_rdoc_files = ['README.md', 'doc/user-guide.md']
  s.required_ruby_version = '>= 2.0.0'

  s.add_dependency 'rails', '>= 4.0.2'
  s.add_dependency 'sidekiq'
  s.add_dependency 'httparty'
  s.add_development_dependency "bundler", "~> 1.17"
  s.add_development_dependency "rake", "~> 10.0"
  s.add_development_dependency "rspec", "~> 3.0"
end
