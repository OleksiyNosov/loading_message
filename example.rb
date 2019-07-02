require_relative 'lib/loading_message'

# Your data
elements = ['goldfish', 'tiger shark', 'hammerhead', 'crampfish', 'bass']

loading_message = LoadingMessage.new \
  max: elements.count,
  message: 'Processing data:',
  finish_message: 'It is done'

elements.each do |element|
  # Some processing

  loading_message.increment element

  sleep(1)
end

loading_message.finish
