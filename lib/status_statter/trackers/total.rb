class Total < StatusStatter::Tracker

  def start
    @count = 0
  end

  def record(status)
    @count += 1
  end

  def report
    { total: @count }
  end

end
