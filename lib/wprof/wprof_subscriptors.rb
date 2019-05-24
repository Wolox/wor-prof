class WprofSubscriptors
  def self.subscriptors
    ActiveSupport::Notifications.subscribe 'process_action.action_controller' do |*args|
      event = ActiveSupport::Notifications::Event.new(*args)
      GenProf.new(event, :standard)
    end

    ActiveSupport::Notifications.subscribe 'wprof.service' do |*args|
      event = ActiveSupport::Notifications::Event.new(*args)
      GenProf.new(event, :service)
    end

    ActiveSupport::Notifications.subscribe 'wprof.custom' do |*args|
      event = ActiveSupport::Notifications::Event.new(*args)
      GenProf.new(event, :custom)
    end
  end
end
