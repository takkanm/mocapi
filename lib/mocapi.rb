require "mocapi/version"
require 'rack/request'
require 'yaml'

class Mocapi
  class MockResponse
    class << self
      def load_response_map(response_map_yaml)
        @response_map = YAML.load(File.read(response_map_yaml))
      end

      def response_map
        @response_map || {}
      end
    end

    def initialize(app = nil)
      @app = app
    end

    def call(env)
      request = Rack::Request.new(env)

      response = if @app
        @app.call(env)
      else
        [200, {}, ['']]
      end

      if mock_response = response_map[request.path]
        [
          mock_response['status_code'],
          mock_response['headers'],
          mock_response['body']
        ]
      else
        response
      end
    end

    private

    def response_map
      @response_map ||= MockResponse.response_map
    end
  end

  class ShowRequest
    def initialize(app = nil)
      @app = app
    end

    def call(env)
      request = Rack::Request.new(env)
      response = if @app
        @app.call(env)
      else
        Rack::Response.new(env)
      end

      show_request_detail  request
      show_response_detail response

      response
    end

    def show_request_detail(request)
      show <<-EOS

    Request URI  : #{request.fullpath}
    HTTP Method  : #{request.request_method}
    Path         : #{request.path}
    Content Type : #{request.content_type}
    Query        : #{request.query_string}
    Request Body :
    #{request.body.read}
      EOS

      request.body.rewind
    end

    def show_response_detail(response)
      status_code, headers, body = *response
      max_length = (headers.keys + ['Response Body']).map(&:length).max

      show <<-EOS
    #{'Status Code'.ljust(max_length)} : #{status_code}
      EOS

      headers.each do |key, value|
        show "    #{key.ljust(max_length)} : #{value}"
      end

      show <<-EOS
    #{'Response Body'.ljust(max_length)} :
    #{body.join('\n')}

      EOS
    end

    def show(str)
      STDOUT.puts str
    end
  end
end
