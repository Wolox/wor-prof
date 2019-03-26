RSpec.describe 'Wprof Generate Profiling' do
  context 'When Im profiling' do
    context 'spected some params' do
      before do
        allow(GenProf).to receive(:deploy_reporter)
      end
      it 'If rec_type as standard' do
        new_gen_prof = GenProf.new(Event.new, :standard)
        params_exp = %i[transaction_id total_time start_dt end_dt code controller url db_runtime]
        params_got = new_gen_prof.instance_variable_get(:@params).keys
        expect(params_got).to eq(params_exp)
      end
      it 'If rec_type as service' do
        new_gen_prof = GenProf.new(Event.new, :service)
        params_exp = %i[transaction_id total_time start_dt end_dt code service_hostname request_uri]
        params_got = new_gen_prof.instance_variable_get(:@params).keys
        expect(params_got).to eq(params_exp)
      end
      it 'If rec_type as custom' do
        new_gen_prof = GenProf.new(Event.new, :custom)
        params_exp = %i[transaction_id total_time start_dt end_dt method]
        params_got = new_gen_prof.instance_variable_get(:@params).keys
        expect(params_got).to eq(params_exp)
      end
    end
  end
end
