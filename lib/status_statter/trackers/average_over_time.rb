class AverageOverTime < StatusStatter::Tracker

  def start
    @count = 0
    @start_time = Time.now
  end

  def record(status)
    @count += 1
  end

  def stop
    @stop_time = Time.now
  end

  def duration_seconds
    @stop_time - @start_time
  end

  def duration_minutes
    duration_seconds / 60.0
  end

  def duration_hours
    duration_seconds / 3600.0
  end

  def display_duration
    ds = (duration_seconds % 60)
    dm = (duration_seconds % 3600 / 60).floor
    dh = (duration_seconds / 3600).floor
    "#{'%02.0f'%dh}:#{'%02.0f'%dm}:#{'%02.0f'%ds}"
  end


  def report
    { start: @start_time,
      stop: @stop_time,
      duration: display_duration,
      total: @count,
      average_per_second: @count / duration_seconds,
      average_per_minute: @count / duration_minutes,
      average_per_hour:   @count / duration_hours }
  end

end
