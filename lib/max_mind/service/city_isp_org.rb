module MaxMindGeoIp
  class CityIspOrgService < Service

    self.base_path = '/f'

    def parsed_response
      if self.valid_response?
        parsed_response = CSV.parse_line(response)
        {
          :ip_country => parsed_response[0],
          :ip_state => parsed_response[1],
          :ip_city => parsed_response[2],
          :ip_postal_code => parsed_response[3],
          :ip_latitude => parsed_response[4],
          :ip_longitude => parsed_response[5],
          :ip_isp => parsed_response[8],
          :ip_org => parsed_response[9],

          :api_response => response
        }
      else
        {
          :api_response => response
        }
      end
    end

    def valid_response?
      super && !(response =~ /,,,,,,,,,,(.+?)/)
    end

  end
end