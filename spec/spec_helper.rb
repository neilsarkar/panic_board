require_relative '../app'
require "webmock/rspec"
require "pry"

RSpec.configure do |config|
  WebMock.disable_net_connect!
end
