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

    "Time: #{ delta } seconds."
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
end
