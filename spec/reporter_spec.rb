RSpec.describe 'Wprof Generate Profiling' do
  require 'spec_helper'
  context 'When I try to gen a Report' do
    context 'with Standard rec_type' do
      before do
        allow(GenProf).to receive(:deploy_reporter)
      end
      let(:data) do
        new_gen_prof = GenProf.new(Event.new, :standard)
        new_gen_prof.instance_variable_get(:@params)
      end
      let(:rec_type) { :standard }
      let(:spect_param) do
        %i[transaction_id total_time start_dt end_dt code controller url db_runtime]
      end
      let(:record) { WprofReporter.new.perform(data, rec_type) }

      it 'And reporter Type wasnt defined' do
        allow(WProf::Config).to receive_messages(get_value: '')
        expect(record.keys).to eq(spect_param)
      end

      it 'And reporter Type is LOGGER' do
        allow(WProf::Config).to receive_messages(get_value: 'LOGGER')
        expect(record.keys).to eq(spect_param)
      end

      it 'And reporter Type is DATABASE' do
        allow(WProf::Config).to receive_messages(get_value: 'DATABASE')
        expect(record.keys).to eq(spect_param)
      end

      describe 'And reporter Type is EXTERNAL' do
        before do
          stub_request(:post, 'http://www.wprof.com/reporter')
          WProf::Configuration.configure do |config|
            config.reporter_type = 'EXTERNAL'
            config.external_url = 'http://www.wprof.com/reporter'
            config.external_headers = { headers: { 'User-Agent' => 'Httparty' } }
            config.disable_wprof = true
          end
        end
        it 'validate ok status' do
          expect(record.ok?).to eq(true)
        end
        it 'validate body' do
          expect(record.request.options[:body]).to eq(data)
        end
        it 'add headers and validate' do
          expect(record.request.options[:headers]).to eq(WProf::Config.external_headers[:headers])
        end
        it 'send post without set url expected handled error' do
          WProf::Config.external_url = nil
          specific_msg = 'bad argument (expected URI object or URI string)'
          msj = "An error was raised when WProf tried to send data to reporter: #{specific_msg}"
          expect(record).to eq(msj)
        end
      end

      describe 'And reporter Type is FILE' do
        before do
          WProf::Configuration.configure do |config|
            config.reporter_type = 'FILE'
            config.csv_type = 'SPLIT'
            config.disable_wprof = true
          end
          allow_any_instance_of(Wprof::Reporters::FileReport).to receive(:write_split_file).and_return(data)
        end
        it 'validate data recived' do
          expect(record.keys).to eq(spect_param)
        end
      end
    end
  end
end
