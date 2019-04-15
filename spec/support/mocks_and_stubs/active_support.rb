module ActiveSupport
  class Notifications
    def self.instrument(foo, arg)
      { subscripted_to: foo }.merge(arg)
    end

    def self.subscribe(*args)
      args
    end
  end
end
