module WProf
  module Configuration
    def self.configure
      yield Config
      initiate_wprof
    end

    def self.initiate_wprof
      WprofSubscriptors.subscriptors unless WProf::Config.disable_wprof
    end
  end

  module Config
    DEFAULTS_CONFIGS = {
      db_runtime: true,
      reporter_type: 'LOGGER',
      csv_type: 'SPLIT',
      async: false,
      httparty_methods_to_trace: %w[get put delete post patch].freeze,
      external_url: nil,
      external_headers: nil,
      custom_methods: nil,
      file_path: Rails.root.to_s,
      disable_wprof: false
    }.freeze

    module_function

    DEFAULTS_CONFIGS.each do |key, value|
      define_method key do
        instance_variable_get("@#{key}") || instance_variable_set("@#{key}", value)
      end

      define_method "#{key}=" do |v|
        instance_variable_set("@#{key}", v)
      end
    end

    def get_value(param)
      value = send(param)
      return value unless value.nil?
      DEFAULTS_CONFIGS[param]
    end
  end
end
