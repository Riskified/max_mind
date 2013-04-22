require File.dirname(__FILE__) + '/spec_helper.rb'

describe MaxMindGeoIp do

  it "should specify version as a constant" do
    MaxMindGeoIp::VERSION.should_not be_nil
  end
  
end
