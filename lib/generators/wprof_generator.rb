class WprofGenerator < Rails::Generators::Base
  desc 'This generator creates an initializer file for Wor-Prof!'
  def wor_prof_init
    create_file 'config/initializers/wprof.rb', init_wprof
  end

  private

  def init_wprof
    <<~CONTENT
    # -----------------------------------------
    # Uncomment and set for use custom options.
    # -----------------------------------------
    WProf::Configuration.configure do |config|
      ## Save DB Runtime?: Default: true 
      # config.db_runtime = true
      ## Reporter Type (¿When we will save our data?): 'LOGGER' by default.
      ## Another options: 'FILE' (For CSV), 'DATABASE' (For Rails DB), 'EXTERNAL' (For external API).
      # config.reporter_type = 'LOGGER'
      ## CSV Type (One CSV file for each type of data or all together)
      ## 'SPLIT' by default, Options: 'MIX'
      # config.csv_type = 'SPLIT' 
      ## Reporter must be work async? Default: false
      # config.async = false
      ## Httparty Methods to wrapper.
      # config.httparty_methods_to_trace = ['get', 'put', 'delete', 'post']
      ## External URL for hit when Reporter Type is EXTERNAL
      ## DEFAULT: nil
      # config.external_url = 'http://example-url/reporter'
      ## Define Headers for Reporter Type when is EXTERNAL.
      ## Must be a Hash (see HTTPARTY doc for more info)
      ## DEFAULT: nil
      # config.external_headers = { headers: {'User-Agent' => 'Httparty'}}
      ## Define your Custom Methods here! (Must be an Array)
      # config.custom_methods = [ 'my_great_method' ]
      ## Define your own path for save Files when Reporter Type is FILE
      ## By default Wor-Prof use Rails.root
      # config.file_path = '/home/mcolombo/examplefolder'
    end
    ## Initiate Wprof
    WprofSubscriptors.subscriptors
    CONTENT
  end
end
