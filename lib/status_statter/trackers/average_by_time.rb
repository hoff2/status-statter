class AverageByTime

  # The created_at values given by Twitter::Tweet are at the
  # resolution of seconds. There are no nanoseconds in them.
  def initialize
    # @counts = {
    #   second: Hash.new{ |h, k| h[k] = 0 },
    #   minute: Hash.new{ |h, k| h[k] = 0 },
    #   hour:   Hash.new{ |h, k| h[k] = 0 } }
  end

  def record(status)
    time = status.created_at
    start_of_minute = time - time.sec
    start_of_hour = minute - minute.min
    @counts[:second][time] += 1
    @counts[:minute][start_of_minute] += 1
    @counts[:hour][start_of_hour] += 1
  end

  def report
    { average_per_second: @counts[:second].values.average,
      average_per_minute: @counts[:minute].values.average,
      average_per_hour:   @counts[:hour].values.average }
  end

end
