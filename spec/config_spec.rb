RSpec.describe 'Wprof Configuration File' do
  context 'Check default values defined in class' do
    let(:defaults) { WProf::Config::DEFAULTS_CONFIGS }

    it 'for db_runtime' do
      expect(defaults[:db_runtime]).to eq(true)
    end
    it 'for reporter_type' do
      expect(defaults[:reporter_type]).not_to be nil
    end
    it 'csv_type' do
      expect(defaults[:csv_type]).to eq('SPLIT')
    end
    it 'for async' do
      expect(defaults[:async]).to eq(false)
    end
    it 'for httparty_methods_to_trace' do
      http_methods = :httparty_methods_to_trace
      expect(defaults[http_methods]).to eq(%w[get put delete post patch])
    end
    it 'for external_url' do
      expect(defaults[:external_url]).to be nil
    end
    it 'for external_headers' do
      expect(defaults[:external_headers]).to be nil
    end
    it 'for custom_methods' do
      expect(defaults[:custom_methods]).to be nil
    end
    it 'file_path' do
      expect(defaults[:file_path]).to eq('path')
    end
  end

  context 'When I try to get an value' do
    let(:config) { WProf::Config }

    context 'And it is not in config' do
      context 'must bring default value' do
        it 'for reporter_type' do
          expect(config.get_value(:reporter_type)).not_to be nil
        end
        it 'for db_runtime' do
          expect(config.get_value(:db_runtime)).to eq(true)
        end
        it 'for async' do
          expect(config.get_value(:async)).to eq(false)
        end
      end
    end

    context 'And it is in config' do
      before do
        WProf::Configuration.configure do |config|
          config.csv_type = 'MIX'
        end
      end
      it 'must bring config value' do
        expect(config.get_value(:csv_type)).to eq('MIX')
      end
    end
  end
end
