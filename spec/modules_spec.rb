URL = 'http://www.testexternal.com/external'.freeze

RSpec.describe 'Wprof Generate Profiling' do
  context 'When include Wprof to a class' do
    before do
      WProf::Configuration.configure do |config|
        config.custom_methods = ['foo_method']
        config.disable_wprof = true
      end
      # allow(Rails).to receive_messages(wprof: { custom_methods: ['foo_method'] })
      require 'support/mocks_and_stubs/class_for_modules'
      allow(GenProf).to receive_messages(deploy_reporter: self)
      stub_request(:get, URL)
    end
    let(:test_class) { ClassForModules.new }

    it 'Wprof must be wrapper httparty methods' do
      expect(test_class.consume_external_service[:subscripted_to]).to eq('wprof.service')
    end
    it 'Wprof must be wrapper custom method' do
      params = test_class.foo_method
      expect(params[:subscripted_to]).to eq('wprof.custom'), 'Wprof hasn\'t subscripted to custom'
      expect(params[:method]).to eq('foo_method'), 'Method field missing into params'
    end
  end
end
