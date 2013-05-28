require 'bundler/setup'
require 'sinatra/base'

class Server < Sinatra::Base
  get "/ucb" do
    haml :ucb
  end
end
