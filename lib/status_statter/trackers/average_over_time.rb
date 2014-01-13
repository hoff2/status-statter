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
      stop: @stop_time,
      duration: "#{'%02.0f'%dh}:#{'%02.0f'%dm}:#{'%02.0f'%ds}",
      total: @count,
      average_per_second: @count / ds,
      average_per_minute: @count / dm,
      average_per_hour:   @count / dh }
  end

end
