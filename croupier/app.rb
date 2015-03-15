require 'sinatra'
require 'json'

require 'sidekiq/web'

require 'autoscaler/sidekiq'
require 'autoscaler/heroku_scaler'

require_relative 'croupier'
require_relative 'workers/run_game_worker'

set :bind, '0.0.0.0'

Sidekiq.configure_client do |config|
  config.redis = {
      :url => ENV['REDISCLOUD_URL'],
      :namespace => 'LeanPokerCroupier'
  }

  unless ENV['HEROKU_API_KEY'].empty?
    config.client_middleware do |chain|
      chain.add Autoscaler::Sidekiq::Client, 'default' => Autoscaler::HerokuScaler.new
    end
  end
end

Sidekiq.configure_server do |config|
  config.redis = {
      :url => ENV['REDISCLOUD_URL'],
      :namespace => 'LeanPokerCroupier'
  }

  unless ENV['HEROKU_API_KEY'].empty?
    config.server_middleware do |chain|
      chain.add(Autoscaler::Sidekiq::Server, Autoscaler::HerokuScaler.new, 240) # 240 second timeout
    end
  end
end

post '/game' do
  RunGameWorker.perform_async params[:teams],  params[:response_url]
  JSON.generate success: true
end

get '/check' do
  JSON.generate success: true
end