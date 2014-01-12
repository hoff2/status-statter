class AverageOverTime

  # The created_at values given by Twitter::Tweet are at the
  # resolution of seconds. There are no nanoseconds in them.
  def initialize
    @count = 0
  end

  def start
    @start_time = Time.now
  end

  def record(status)
    @count += 1
  end

  def stop
    @stop_time = Time.now
  end

  def duration_in_seconds
    @stop_time - @start_time
  end

  def duration_in_minutes
    duration_in_seconds / 60
  end

  def duration_in_hours
    duration_in_minutes / 60
  end

  def report
    { average_per_second: @count / duration_in_seconds,
      average_per_minute: @count / duration_in_minutes,
      average_per_hour:   @count / duration_in_hours }
  end

end
