if Rails.env == 'production'
  #puts REDISTO_GO_URL
  uri = URI.parse(REDISTO_GO_URL)
  REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
  Resque.redis = REDIS
end
