require './lib/mocapi'

use Mocapi::ShowRequest

Mocapi::MockResponse.load_response_map('./sample/response_map.yaml')

run Mocapi::MockResponse.new
