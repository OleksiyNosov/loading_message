require_relative '../lib/loading_message'

elements = ['goldfish', 'tiger shark', 'hammerhead', 'crampfish']

loading_message = LoadingMessage.new(max: elements.count)

elements.each do |element|
  # Some processing

  (1..2_500_000).map(&:to_s)

  loading_message.increment
end

loading_message.finish
