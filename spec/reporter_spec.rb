RSpec.describe 'Wprof Generate Profiling' do
  require 'spec_helper'
  context 'When I try to gen a Report' do
    context 'with Standard rec_type' do
      before do
        allow(GenProf).to receive(:deploy_reporter)
      end
      # params_exp = %i[transaction_id total_time start_dt end_dt code controller url db_runtime]
      let(:data) do
        new_gen_prof = GenProf.new(Event.new, :standard)
        new_gen_prof.instance_variable_get(:@params)
      end
      let(:rec_type) { :standard }
      let(:spect_param) do
        %i[transaction_id total_time start_dt end_dt code controller url db_runtime]
      end

      it 'And reporter Type wasnt defined' do
        allow(WProf::Config).to receive_messages(get_value: '')
        record = WprofReporter.new.perform(data, rec_type)
        expect(record.keys).to eq(spect_param)
      end

      it 'And reporter Type is LOGGER' do
        allow(WProf::Config).to receive_messages(get_value: 'LOGGER')
        record = WprofReporter.new.perform(data, rec_type)
        expect(record.keys).to eq(spect_param)
      end

      it 'And reporter Type is DATABASE' do
        allow(WProf::Config).to receive_messages(get_value: 'DATABASE')
        record = WprofReporter.new.perform(data, rec_type)
        expect(record.keys).to eq(spect_param)
      end

      describe 'And reporter Type is EXTERNAL' do
        before do
          stub_request(:post, 'http://www.wprof.com/reporter')
        end
        it 'validate ok status' do
          allow(Rails).to receive_messages(wprof: { reporter_type: 'EXTERNAL',
                                                    external_url: 'http://www.wprof.com/reporter' })
          record = WprofReporter.new.perform(data, rec_type)
          expect(record.ok?).to eq(true)
        end
        it 'validate body' do
          allow(Rails).to receive_messages(wprof: { reporter_type: 'EXTERNAL',
                                                    external_url: 'http://www.wprof.com/reporter' })
          record = WprofReporter.new.perform(data, rec_type)
          expect(record.request.options[:body]).to eq(data)
        end
        it 'add headers and validate' do
          headers = { headers: { 'User-Agent' => 'Httparty' } }
          allow(Rails).to receive_messages(wprof: { reporter_type: 'EXTERNAL',
                                                    external_url: 'http://www.wprof.com/reporter',
                                                    external_headers: headers })
          record = WprofReporter.new.perform(data, rec_type)
          expect(record.request.options[:headers]).to eq(headers[:headers])
        end
        it 'send post without set url expected handled error' do
          allow(Rails).to receive_messages(wprof: { reporter_type: 'EXTERNAL' })
          record = WprofReporter.new.perform(data, rec_type)
          expect(record).to eq('An error was raised when WProf tried to send data to reporter: bad argument (expected URI object or URI string)')
        end
      end
    end
  end
end
