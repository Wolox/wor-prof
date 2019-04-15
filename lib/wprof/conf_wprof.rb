module WProf
  class Config
    DEFAULTS_CONFIGS = {
      db_runtime: true,
      reporter_type: 'LOGGER',
      csv_type: 'SPLIT',
      async: false,
      httparty_methods_to_trace: %w[get put delete post patch].freeze,
      external_url: nil,
      external_headers: nil,
      custom_methods: nil,
      file_path: Rails.root.to_s
    }.freeze

    class << self
      def get_value(param)
        unless Rails.application.nil?
          value = Rails.configuration.x.wprof[param]
          return value unless value.nil?
        end
        DEFAULTS_CONFIGS[param]
      end
    end
  end
end
