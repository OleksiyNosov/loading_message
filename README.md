## Setup

```sh
rvm install 2.6.3
rvm use 2.6.3@loading_message --create
gem install bundle
bundle install
```

## Usage example

```rb
# Your data
elements = ['goldfish', 'tiger shark', 'hammerhead', crampfish]

loading_message = LoadingMessage.new \
  max: elements.count,
  message: 'Processing data:',
  finish_message: "It is done"

elements.each do |element|
  # Some processing

  loading_message.increment
end

loading_message.finish
```

## Hardcode load

```rb
loading_message_url = 'https://raw.githubusercontent.com/OleksiyNosov/loading_message/master/lib/loading_message.rb'

puts `if [[ -f /tmp/loading_message ]]; then rm -r /tmp/loading_message fi`
puts `mkdir /tmp/loading_message`
puts `curl -o /tmp/loading_message/loading_message.rb #{ loading_message_url }`

require_relative '/tmp/loading_message/loading_message.rb'
```
