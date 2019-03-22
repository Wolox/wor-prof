require 'wprof/version'
require 'wprof/conf_wprof'
require 'wprof/reporters/db_report'
require 'wprof/reporters/external_report'
require 'wprof/reporters/file_report'
require 'wprof/wprof_reporter'
require 'wprof/gen_prof'
require 'wprof/wprof_subscriptors'

module Wprof
  def self.included(base)
    load 'wprof/wprof_modules.rb'
    base.extend(ForHttparty) if base.include?(HTTParty)
    base.prepend(CustomMethods) if WProf::Config.get_value(:custom_methods).present?
  end
end
