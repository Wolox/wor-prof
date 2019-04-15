class Rails
  class << self
    def application
      'mockApp'
    end

    def root
      'path'
    end

    def configuration
      self
    end

    def x
      self
    end

    def wprof
      { csv_type: 'MIX' }
    end

    def logger
      self
    end

    def warn(msg)
      msg
    end

    def info(msg)
      msg
    end
  end
end
