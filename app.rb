require 'bundler/setup'
require 'sinatra/base'
require 'sinatra/namespace'
require 'nokogiri'
require 'twitter'
require 'instagram'

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

    get "/instagram" do
      Instagram.configure do |config|
        config.client_id = ENV["INSTAGRAM_CLIENT_ID"]
        config.client_secret = ENV["INSTAGRAM_CLIENT_SECRET"]
      end

      client = Instagram.client(access_token: ENV["INSTAGRAM_ACCESS_TOKEN"])

      cams_photo  = client.user_recent_media(31713).first
      joeys_photo = client.user_recent_media(7560612).first
      neils_photo = client.user_recent_media(18172731).first

      json = {
        cam: {
          image_url: cams_photo.images.standard_resolution.url,
          text: cams_photo.caption.try(:text),
          likes: cams_photo.likes.count
        },
        joey: {
          image_url: joeys_photo.images.standard_resolution.url,
          text: joeys_photo.caption.try(:text),
          likes: joeys_photo.likes.count
        },
        neil: {
          image_url: neils_photo.images.standard_resolution.url,
          text: neils_photo.caption.try(:text),
          likes: neils_photo.likes.count
        }
      }

      Yajl::Encoder.encode(json)
    end

    get "/foursquare" do
      def get_last_checkin(user_id)
        puts "https://api.foursquare.com/v2/users/#{user_id}/checkins?oauth_token=#{ENV["FOURSQUARE_ACCESS_TOKEN"]}"
        json = open("https://api.foursquare.com/v2/users/#{user_id}/checkins?oauth_token=#{ENV["FOURSQUARE_ACCESS_TOKEN"]}")
        Yajl::Parser.parse(json).first
      end

      users = {
        neil: 23118,
        cam: 244383,
        joey: 25168764
      }

      checkins = {}

      users.each do |name, id|
        checkins[name] = get_last_checkin(id)
      end

      Yajl::Encoder.encode(checkins)
    end

    get "/poncho" do
      json = Yajl::Parser.parse(open('http://poncho.is/s/1Sm6X/json/'))['data']

      Yajl::Encoder.encode(json)
    end
  end

  get "/:page" do
    haml params[:page].to_sym
  end
end
