require 'open-uri'
require 'yajl'

class JsonFetcher
  def self.fetch(url, parse_results = true, &block)
    response = "nice"
    open(url) do |f|
      response = f.read
    end

    response = Yajl::Parser.parse(response) rescue response

    response = yield(response) if block_given?

    if parse_results
      Yajl::Encoder.encode(response) rescue response
    else
      response
    end
  end
end
