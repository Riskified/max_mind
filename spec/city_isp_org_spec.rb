require File.dirname(__FILE__) + '/spec_helper.rb'

describe MaxMindGeoIp::CityIspOrgService do
  
  it "base_path should be /f by default" do
    MaxMindGeoIp::CityIspOrgService.base_path.should == '/f'
  end

  describe "response parsing" do
  
    before(:each) do
      @ip = '12.12.12.12'
      MaxMindGeoIp::CityIspOrgService.license_key = '1234'
    end
  
    it "should return a hash of values if response is valid" do
      @valid_response = 'US,NY,Brooklyn,11222,40.728001,-73.945297,501,718,"Road Runner","Road Runner"'
      Net::HTTP.stub!(:get).and_return(@valid_response)
      @response = MaxMindGeoIp::CityIspOrgService.fetch_for_ip(@ip)
      @response.should == {:ip_latitude=>"40.728001", :ip_longitude=>"-73.945297", :ip_country_code=>"US", :ip_city=>"Brooklyn", :ip_postal_code=>"11222", :ip_region=>"NY", :ip_isp=>"Road Runner",:ip_org=>"Road Runner",:api_response => @valid_response}
    end

    ['WHAteVEr', 'g@rbag3', '432153'].each do |r|
      it "should return nil if response is invalid" do
        @invalid_response = ",,,,,,,,,,#{r}"
        Net::HTTP.stub!(:get).and_return(@invalid_response)
        @response = MaxMindGeoIp::CityIspOrgService.fetch_for_ip(@ip)
        @response.should == {:api_response => @invalid_response}
      end
    end

  end

end
