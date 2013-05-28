require 'open-uri'
require 'yajl'

class JsonFetcher
  def self.fetch(url, &block)
    response = "nice"
    open(url) do |f|
      response = f.read
    end

    response = Yajl::Parser.parse(response) rescue response

    yield(response) if block_given?

    response
  end
end
