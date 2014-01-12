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

  def ds
    @stop_time - @start_time
  end

  def dm
    ds / 60
  end

  def dh
    dm / 60
  end

  def report
    { start: @start_time,
      stop:  @stop_time,
      duration: "#{dh}:#{dm}:#{ds}",
      average_per_second: @count / duration_in_seconds,
      average_per_minute: @count / duration_in_minutes,
      average_per_hour:   @count / duration_in_hours }
  end

end
