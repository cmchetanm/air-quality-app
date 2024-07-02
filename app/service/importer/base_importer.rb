# This importer is used to make Http request to Open Wheather Map API
module Importer
	class BaseImporter
		attr_reader :base_url
	  
	  def initialize(base_url)
      @base_url = base_url
    end

		def get_request(path, params = {})
	    uri = create_uri(path, params)
	    make_request(Net::HTTP::Get, uri)
	  end

	  private

	  def create_uri(path, params = {})
	    uri = URI.parse("#{base_url}/#{path}")
	    uri.query = URI.encode_www_form(params) unless params.empty?
	    uri
	  end

	  def make_request(request_type, uri, data = nil)
	    http = Net::HTTP.new(uri.hostname, uri.port)
	    request = request_type.new(uri)
	    request.content_type = 'application/json'
	    request.body = data.to_json if data
	    response = http.request(request)
	    handle_response(response)
	  end

    def handle_response(response)
      case response
      when Net::HTTPSuccess
        JSON.parse response.body
      else
        raise Net::HTTPError, response.message
      end
    end
	end
end