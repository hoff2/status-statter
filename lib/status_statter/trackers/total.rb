class Total

  def initialize
    @count = 0
  end

  def record(status)
    @count += 1
  end

  def report
    "Total: #{@count}"
  end

end
