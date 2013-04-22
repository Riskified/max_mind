module MaxMindGeoIp
  class CityService < Service

    self.base_path = '/b'

    def parsed_response
      if self.valid_response?
        parsed_response = CSV.parse_line(self.response)
        {
          :ip_country => parsed_response[0],
          :ip_state => parsed_response[1],
          :ip_city => parsed_response[2],
          :ip_latitude => parsed_response[3],
          :ip_longitude => parsed_response[4],
          :api_response => self.response
        }
      else
        {
          :api_response => self.response
        }
      end
    end

    def valid_response?
      super && !(self.response =~ /,,,,,(.+?)/)
    end

  end
end