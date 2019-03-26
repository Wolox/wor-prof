require 'bundler/setup'
require 'byebug'
require 'support/mocks_and_stubs/rails_config_mock'
require 'webmock/rspec'
require 'support/mocks_and_stubs/event_mock'
require 'support/mocks_and_stubs/wprof_controller_mock'
require 'wprof/gen_prof'
require 'sidekiq'
require 'wprof/reporters/db_report'
require 'wprof/reporters/external_report'
require 'wprof/reporters/file_report'
require 'wprof/wprof_reporter'
require 'wprof/conf_wprof'
require 'httparty'
RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
