require File.dirname(__FILE__) + '/spec_helper.rb'

describe MaxMindGeoIp::CityService do
  
  it "base_path should be /b by default" do
    MaxMindGeoIp::CityService.base_path.should == '/b'
  end

  describe "response parsing" do
  
    before(:each) do
      @ip = '12.12.12.12'
      MaxMindGeoIp::CityService.license_key = '1234'
    end
  
    it "should return a hash of values if response is valid" do
      @valid_response = 'US,NY,Brooklyn,40.728001,-73.945297'
      Net::HTTP.stub!(:get).and_return(@valid_response)
      @response = MaxMindGeoIp::CityService.fetch_for_ip(@ip)
      @response.should == {:ip_latitude=>"40.728001", :ip_longitude=>"-73.945297", :ip_country_code=>"US", :ip_city=>"Brooklyn", :ip_region=>"NY", :api_response => @valid_response}
    end

    ['WHAteVEr', 'g@rbag3', '432153'].each do |r|
      it "should return nil if response is invalid" do
        @invalid_response = ",,,,,#{r}"
        Net::HTTP.stub!(:get).and_return(@invalid_response)
        @response = MaxMindGeoIp::CityService.fetch_for_ip(@ip)
        @response.should == {:api_response => @invalid_response}
      end
    end

  end

end
