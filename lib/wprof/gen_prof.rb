class GenProf
  include Wprof::Supports::StyleSupport

  def initialize(event, rec_type)
    @event = event
    @db_runtime = WProf::Config.get_value(:db_runtime)
    @async_report = WProf::Config.get_value(:async)
    @rec_type = rec_type
    generate_profiling
  end

  def generate_profiling
    generate_common_params
    generate_custom_params
    deploy_reporter
  end

  private

  def generate_common_params
    @params = {
      transaction_id: @event.transaction_id,
      total_time: format_time(@event.duration),
      start_dt: @event.time,
      end_dt: @event.end
    }
  end

  def generate_custom_params
    case @rec_type
    when :standard
      app_params
    when :service
      service_params
    when :custom
      custom_params
    end
  end

  def app_params
    for_app_only = {
      code: @event.payload[:status],
      controller: @event.payload[:controller],
      url: @event.payload[:path]
    }
    for_app_only[:db_runtime] = format_time(@event.payload[:db_runtime]) if @db_runtime
    @params.merge!(for_app_only)
  end

  def service_params
    for_service_only = {
      code: @event.payload[:status],
      service_hostname: @event.payload[:service_hostname],
      request_uri: @event.payload[:request_uri]
    }
    @params.merge!(for_service_only)
  end

  def custom_params
    for_customs_only = {
      method: @event.payload[:method]
    }
    @params.merge!(for_customs_only)
  end

  def deploy_reporter
    if @async_report
      WprofReporter.perform_async(@params, @rec_type)
    else
      WprofReporter.new.perform(@params, @rec_type)
    end
  end
end
