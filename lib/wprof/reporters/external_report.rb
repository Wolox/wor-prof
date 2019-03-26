module Wprof
  module Reporters
    module ExternalReport
      def generate_external_report
        options = { body: @data }
        headers = WProf::Config.get_value(:external_headers)
        options.merge!(headers) unless headers.nil?
        HTTParty.post(WProf::Config.get_value(:external_url),
                      options)
      end
    end
  end
end
