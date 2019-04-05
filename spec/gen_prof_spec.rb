RSpec.describe 'Wprof Generate Profiling' do
  context 'When Im profiling' do
    context 'spected some params' do
      before do
        allow(GenProf).to receive(:deploy_reporter)
      end
      let(:params_exp) { %i[transaction_id total_time start_dt end_dt] }
      let(:new_gen_prof) do
        ->(rec_type) { GenProf.new(Event.new, rec_type) }
      end
      let(:params_got) do
        ->(rec_type) { new_gen_prof[rec_type].instance_variable_get(:@params).keys }
      end

      it 'If rec_type as standard' do
        params_exp.concat(%i[code controller url db_runtime])
        expect(params_got[:standard]).to eq(params_exp)
      end
      it 'If rec_type as service' do
        params_exp.concat(%i[code service_hostname request_uri])
        expect(params_got[:service]).to eq(params_exp)
      end
      it 'If rec_type as custom' do
        params_exp.concat(%i[method])
        expect(params_got[:custom]).to eq(params_exp)
      end
    end
  end
end
