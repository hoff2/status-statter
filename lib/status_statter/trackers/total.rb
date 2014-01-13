class Total

  def start
    @count = 0
  end

  def record(status)
    @count += 1
  end

  def stop; end

  def report
    { total: @count }
  end

end
