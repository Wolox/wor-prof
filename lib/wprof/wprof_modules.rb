module ForHttparty
  httparty_methods_to_trace = WProf::Config.get_value(:httparty_methods_to_trace)
  httparty_methods_to_trace.each do |name_method|
    define_method(name_method.to_s) do |*arg|
      ActiveSupport::Notifications.instrument 'wprof.service', data = {} do
        rest = super(*arg)
        begin
          data[:status] = rest&.code
          data[:service_hostname] = rest&.request&.path&.hostname
          data[:request_uri] = rest&.request&.path&.request_uri
        rescue StandardError => e
          err_message = "WProf ERROR when try parsing service response: #{e}"
          Rails.logger.warn(err_message)
        end
        rest
      end
    end
  end
end

module CustomMethods
  custom_methods = WProf::Config.get_value(:custom_methods)
  unless custom_methods.nil?
    custom_methods.each do |name_method|
      define_method(name_method.to_s) do |*arg|
        ActiveSupport::Notifications.instrument 'wprof.custom', method: name_method.to_s do
          super(*arg)
        end
      end
    end
  end
end