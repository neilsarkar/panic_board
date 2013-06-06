require 'bundler/setup'
require 'sinatra/base'
require 'sinatra/namespace'
require 'nokogiri'
require 'twitter'

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

    get "/tweets" do
      def last_tweet(username)
        Twitter.user_timeline(username).detect do |tweet|
          tweet.in_reply_to_user_id.nil?
        end
      end

      cams_tweet = last_tweet("camh")
      joeys_tweet = last_tweet("joeypfeifer")
      neils_tweet = last_tweet("neilsarkar")

      json = {
        cam: {
          text: cams_tweet.text,
          avatar_url: cams_tweet.user.profile_image_url
        },
        joey: {
          text: joeys_tweet.text.gsub(/pizza/i, "cock"),
          avatar_url: joeys_tweet.user.profile_image_url
        },
        neil: {
          text: neils_tweet.text,
          avatar_url: neils_tweet.user.profile_image_url
        }
      }

      Yajl::Encoder.encode(json)
    end
  end

  get "/:page" do
    haml params[:page].to_sym
  end
end
