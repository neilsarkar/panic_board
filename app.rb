require 'bundler/setup'
require 'sinatra/base'

require_relative './lib/json_fetcher'

class App < Sinatra::Base
  get "/ucb" do
    haml :ucb
  end
end
