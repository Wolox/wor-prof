module Wprof
  module Reporters
    module DatabaseReport
      def db_report
        case @rec_type
        when :service
          WprofService.create(@data)
        when :standard
          WprofController.create(@data)
        when :custom
          WprofMethod.create(@data)
        end
      end
    end
  end
end
