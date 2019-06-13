class LoadingMessage
  attr_reader :min, :max, :step, :message, :loading_index, :finish_message, :start_time, :finish_time

  def initialize(min: 0, max: 100, step: 1, message: 'Working:', finish_message: 'Done.')
    @min = min
    @max = max
    @step = step
    @message = message
    @finish_message = finish_message

    @loading_index = 0.0
  end

  def increment
    @loading_index += 1
    @start_time ||= Time.now

    printf("\r#{ message } %.2f%%", loading_index / max * 100)
  end

  def finish
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
