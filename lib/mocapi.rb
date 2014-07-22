require "mocapi/version"
require 'rack/request'
require 'yaml'
require 'erb_with_hash'

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
      erb_text = view_path.join('request.erb').read
      show ERB.new(erb_text, nil, '-').result_with_hash(request: request.dup)

      request.body.rewind
    end

    def show_response_detail(response)
      erb_text = view_path.join('response.erb').read
      show ERB.new(erb_text, nil, '-').result_with_hash(response: response.dup)
    end

    def show(str)
      STDOUT.puts str
    end

    private

    def view_path
      Pathname.new(__dir__).join('view')
    end
  end
end
