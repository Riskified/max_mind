require File.dirname(__FILE__) + '/spec_helper.rb'

describe MaxMindGeoIp::Service do
  
  before(:each) do
    MaxMindGeoIp::Service.license_key = nil
  end
  
  describe "class attributes" do 

    it "should have a @@base_url defined" do
      MaxMindGeoIp::Service.base_url.should_not be_nil
    end

    it "@@base_url should be http://geoip1.maxmind.com by default" do
      MaxMindGeoIp::Service.base_url.should == 'http://geoip.maxmind.com'
    end

    it "should have no license_key initially" do
      MaxMindGeoIp::Service.license_key.should == nil
    end

    it "should have no base_path initially" do
      MaxMindGeoIp::Service.base_path.should == nil
    end

  end

  describe "class and instance methods" do

    before(:each) do
      @ip = '12.12.12.12'
      @sample_response = 'US,NY,Brooklyn,11222,40.728001,-73.945297,501,718,"Road Runner","Road Runner"'
      @base_path = '/z'
      Net::HTTP.stub!(:get).and_return(@sample_response)
      MaxMindGeoIp::Service.stub!(:base_path).and_return(@base_path)
    end

    describe ".fetch_for_ip" do
  
      it "should raise a license error if api key is not set" do
        expect {
          MaxMindGeoIp::Service.fetch_for_ip(@ip)
        }.to raise_error(MaxMindGeoIp::LicenseError)
      end

      describe "with license key but without a base_url" do

        it "should raise a RequestError" do
          MaxMindGeoIp::Service.license_key = '1234'
          MaxMindGeoIp::Service.fetch_for_ip(@ip).should == @sample_response
        end

      end

    end
    
    describe ".license_key=" do
    
      it "allows the service subclass to inherit the license key" do
        MaxMindGeoIp::Service.license_key = 'abcdefg'
        MaxMindGeoIp::CityService.license_key.should == 'abcdefg'
      end
      
    end
    
    describe ".base_url=" do
      it "allows the service subclass to inherit the license key" do
        MaxMindGeoIp::Service.base_url = 'http://geoip3.maxmind.com'
        MaxMindGeoIp::CityService.base_url.should == 'http://geoip3.maxmind.com'
      end
    end
    
    

    describe "instance methods" do
    
      before(:each) do
        MaxMindGeoIp::Service.license_key = '1234'
        @service = MaxMindGeoIp::Service.new
      end
    
      it "should make request" do
        @service.make_request(@ip).should == @sample_response
      end
    
      it "should build a proper path" do
        query_params = {:meow => '1', :woof => '2'}
        @service.build_path(query_params).should == "#{@base_path}?#{query_params.to_query_string}"
      end

      it "valid_response? should ensure response is not blank" do
        @service = MaxMindGeoIp::Service.new
        @service.valid_response?.should be_false
        @service.response = @sample_response
        @service.valid_response?.should be_true
      end

    end
  
  end

end
