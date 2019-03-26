class WprofReporter
  include Sidekiq::Worker
  include Wprof::Reporters::FileReport
  include Wprof::Reporters::DatabaseReport
  include Wprof::Reporters::ExternalReport

  def perform(data, rec_type)
    @data = data
    @rec_type = rec_type.to_sym
    reporter
  rescue StandardError => error
    Rails.logger.warn("An error was raised when WProf tried to send data to reporter: #{error}")
  end

  def reporter
    reporter_type = WProf::Config.get_value(:reporter_type)
    case reporter_type
    when 'LOGGER'
      logger_report
    when 'FILE'
      generate_file_report
    when 'DATABASE'
      db_report
    when 'EXTERNAL'
      generate_external_report
    else
      logger_report
    end
  end

  def logger_report
    Rails.logger.info(@data)
  end
end
