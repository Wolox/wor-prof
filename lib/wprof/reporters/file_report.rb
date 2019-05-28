module Wprof
  module Reporters
    module FileReport
      def generate_file_report
        require 'csv'
        csv_type = WProf::Config.get_value(:csv_type)
        path = WProf::Config.get_value(:file_path)
        send("write_#{csv_type.downcase}_file", path)
      end

      def write_mix_file(path)
        CSV.open("#{path}/wprof.csv", 'ab') do |csv|
          @data.to_a.each do |elem|
            csv << elem
          end
        end
      end

      def write_split_file(path)
        make_files(path)
        case @rec_type
        when :service
          CSV.open("#{path}/wprofservice.csv", 'ab') do |csv|
            csv << @data.values
          end
        when :standard
          CSV.open("#{path}/wprofcontroller.csv", 'ab') do |csv|
            csv << @data.values
          end
        when :custom
          CSV.open("#{path}/wprofmethods.csv", 'ab') do |csv|
            csv << @data.values
          end
        end
      end

      def make_files(path)
        unless File.exist?("#{path}/wprofservice.csv")
          params = %w[transaction_id total_time start_dt end_dt code service_hostname request_uri]
          CSV.open("#{path}/wprofservice.csv", 'wb') do |csv|
            csv << params
          end
        end
        unless File.exist?("#{path}/wprofcontroller.csv")
          params = %w[transaction_id total_time start_dt end_dt code controller url db_runtime]
          CSV.open("#{path}/wprofcontroller.csv", 'wb') do |csv|
            csv << params
          end
        end
        unless File.exist?("#{path}/wprofmethods.csv") # rubocop:disable Style/GuardClause
          params = %w[transaction_id total_time start_dt end_dt method]
          CSV.open("#{path}/wprofmethods.csv", 'wb') do |csv|
            csv << params
          end
        end
      end
    end
  end
end
