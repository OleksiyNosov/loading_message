class LoadingMessage
  attr_reader :min, :max, :step, :message, :loading_index, :finish_message, :start_time, :finish_time
  attr_reader :previous_message, :current_message, :erase_space

  def initialize(min: 0, max: 100, step: 1, message: 'Working:', finish_message: 'Done.')
    @min = min
    @max = max
    @step = step
    @message = message
    @finish_message = finish_message

    @loading_index = 0.0
  end

  def increment current_message = ''
    @loading_index += 1
    @start_time ||= Time.now

    show_increment current_message
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

    printf("\r#{ message } %.2f%% #{ current_message }#{ erase_space }", percent)

    @previous_message = current_message
  end

  def percent
    loading_index / max * 100
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

  def finish_time
    @finish_time ||= Time.now
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
