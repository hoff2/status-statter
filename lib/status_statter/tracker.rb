class StatusStatter
  class Tracker
    def start; end

    def record(ignored)
      puts "WARNING: your #{self.class.name} probably won't do much for you",
      "without a #record method"
    end

    def stop; end

    def report
      "No #report method defined for #{self.class.name}"
    end
  end
end
