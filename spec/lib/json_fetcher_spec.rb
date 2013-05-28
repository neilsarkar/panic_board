require "spec_helper"

describe JsonFetcher do
  describe ".fetch" do
    it "should get results from a url" do
      stub_request(:get, "http://istheltrainfucked.com").to_return(
        body: "Hi."
      )
      JsonFetcher.fetch("http://istheltrainfucked.com").should == "Hi."

      WebMock.should have_requested(:get, "http://istheltrainfucked.com")
    end

    it "should parse json when possible" do
      stub_request(:get, "http://ucbclassy.com").to_return(
        body: Yajl::Encoder.encode({cool: "nice"})
      )

      JsonFetcher.fetch("http://ucbclassy.com").should == { "cool" => "nice" }
    end

    it "should allow post-processing" do
      stub_request(:get, "http://ucbclassy.com").to_return(
        body: Yajl::Encoder.encode({cool: "nice"})
      )

      JsonFetcher.fetch("http://ucbclassy.com") do |response|
        response.merge!({"great" => "awesome"})
      end.should == { "cool" => "nice", "great" => "awesome"}
    end
  end
end
