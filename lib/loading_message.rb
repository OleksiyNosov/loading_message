require 'json'

class LoadingMessage
  attr_reader :min, :max, :step, :message, :loading_index, :finish_message, :start_time, :finish_time
  attr_reader :previous_message, :current_message, :erase_space, :increment_data, :standard_logger, :logging

  def initialize(min: 0, max: 100, step: 1, message: 'Working:', finish_message: 'Done.', logging: true)
    @min = min
    @max = max
    @step = step
    @message = message
    @finish_message = finish_message
    @logging = logging

    @loading_index = 0.0

    @standard_logger = LoadingLogger.new('loading_message_standard')
  end

  def increment current_message = '', data: {}
    @loading_index += 1
    @start_time ||= Time.now
    @increment_data = {
      loading_index: loading_index.to_i,
      start_time: start_time,
      current_time: current_time,
      percent: string_percent,
      data: data
    }

    show_increment current_message

    standard_logger.log(increment_data) if logging
  end

  def finish
    show_increment

    rows = [
      started_at,
      finished_at,
      time_took,
      finish_message
    ]

    message = rows.join("\n")

    puts "\n#{ message }"
  end

  private

  def show_increment current_message = ''
    @previous_message ||= ''
    message_diff = previous_message.length - current_message.length
    @erase_space = message_diff > 0 ? ' ' * message_diff : ''

    printf("\r#{ message } %.2f%% #{ current_message }#{ erase_space }", string_percent)

    @increment_data[:message] = current_message
    @increment_data[:loading_message] = "#{ message } #{string_percent} #{ current_message }"

    @previous_message = current_message
  end

  def percent
    loading_index / max * 100
  end

  def string_percent
    percent.to_s.gsub(/(?<=\..{2}).*$/, '')
  end

  def time_took
    delta = finish_time - start_time

    "Time: #{ duration_distance(delta) }"
  end

  def started_at
    "Started at: #{ start_time }"
  end

  def finished_at
    "Finished at: #{ finish_time }"
  end

  def current_time
    @current_time ||= Time.now
  end

  def finish_time
    @finish_time ||= current_time
  end

  def duration_distance delta
    strict_delta = delta.to_i

    hours = strict_delta / 3600
    minutes_in_seconds = strict_delta - hours * 3600

    minutes = minutes_in_seconds / 60
    seconds = minutes_in_seconds - minutes * 60

    miliseconds = (delta - strict_delta) * 1_000
    microseconds = (delta - strict_delta) * 1_000_000 % 1_000

    format('%02d:%02d:%02d.%03d.%03d', hours, minutes, seconds, miliseconds, microseconds)
  end
end

class LoadingLogger
  attr_reader :time, :filename, :path, :destination, :first_attempt

  def initialize(name, path: nil, time_postfix: true)
    @time = time_postfix ? Time.now : nil
    @filename = "#{name}_#{time}.log"
    @path = path.to_s.gsub(/(?<=.)\/$/, '')
    @destination = [@path, filename].reject(&:empty?).join('/')
    @first_attempt = true
  end

  def log(data)
    first_write_procedure

    File.open(destination, 'a') { |file| file.puts data.to_json }
  end

  def first_write_procedure
    first_attempt && File.write(destination, '') && @first_attempt = false
  end
end
