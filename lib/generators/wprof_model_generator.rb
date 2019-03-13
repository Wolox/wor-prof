class WprofModelGenerator < Rails::Generators::Base
  desc 'This generator creates all model for use Wor-prof witch reporter_type as Database'
  def wprof_migrations
    making_wprof_migrations
  end

  private

  def making_wprof_migrations
    generate 'model', 'WprofController transaction_id:string:index total_time:float start_dt:datetime end_dt:datetime code:integer:index controller:string url:string:index db_runtime:float'
    generate 'model', 'WprofService transaction_id:string:index total_time:float start_dt:datetime end_dt:datetime code:integer:index service_hostname:string:index request_uri:string:index'
    generate 'model', 'WprofMethod transaction_id:string:index total_time:float start_dt:datetime end_dt:datetime method:string:index'
  end
end
