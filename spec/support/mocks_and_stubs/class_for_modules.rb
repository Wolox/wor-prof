require 'httparty'
require 'support/mocks_and_stubs/rails_config_mock'
require 'support/mocks_and_stubs/event_mock'
require 'support/mocks_and_stubs/wprof_controller_mock'
require 'wprof/supports/style_support'
require 'support/mocks_and_stubs/active_support'
require 'sidekiq'
load 'wor-prof.rb'
class ClassForModules
  include HTTParty
  include Wprof

  def foo_method
    'Im foo'
  end

  def consume_external_service
    self.class.get('http://www.testexternal.com/external')
  end
end
