class Event
  attr_accessor :transaction_id, :time, :end, :payload, :duration

  def initialize
    @transaction_id = Faker::Crypto.md5
    @time = Faker::Number.decimal(2, 4)
    @end = Faker::Number.decimal(2, 4)
    @duration = Faker::Number.decimal(2, 4)
    @payload = { status: %w[200 404].sample,
                 controller: Faker::Internet.domain_word,
                 path: Faker::Internet.url,
                 db_runtime: Faker::Number.decimal(2, 4),
                 service_hostname: Faker::Internet.domain_word,
                 request_uri: Faker::Internet.url,
                 method: Faker::Name.name }
  end
end
