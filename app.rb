require 'bundler/setup'
require 'sinatra/base'
require 'sinatra/namespace'
require 'nokogiri'

require_relative './lib/json_fetcher'

class App < Sinatra::Base
  register Sinatra::Namespace

  get "/" do
    "Hi. Add panels to app.rb"
  end

  namespace "/refresh" do
    before do
      content_type :json
    end

    get "/ucb" do
      JsonFetcher.fetch("http://ucb-classy.herokuapp.com/api/classes")
    end

    get "/ltrain" do
      # This is from the awesome istheltrainfucked.com
      # https://github.com/jgv/is-the-L-train-fucked

      JsonFetcher.fetch('http://mta.info/status/serviceStatus.txt') do |response|
        doc = Nokogiri::XML(open('http://mta.info/status/serviceStatus.txt'))
        status = doc.xpath('//status')[7]

        {
          status_text: status.to_s =~ /GOOD SERVICE/ ? 'nope' : 'yup',
        }
      end
    end
  end

  get "/:page" do
    haml params[:page].to_sym
  end
end
