# Mocapi

Easy Mock Server.

## Installation

Add this line to your application's Gemfile:

    gem 'mocapi'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mocapi

## Usage

write config.ru with set resposne_map.yaml(see example `sample/response_map.yaml`), and rackup.

```
# sample config.ru
require './lib/mocapi'

use Mocapi::ShowRequest

Mocapi::MockResponse.load_response_map('./sample/response_map.yaml')

run Mocapi::MockResponse.new

```

so, you can use  mock server, and show request/response.


## Contributing

1. Fork it ( https://github.com/[my-github-username]/mocapi/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## TODO

- add command line tool
- use erb template
- ignore path
