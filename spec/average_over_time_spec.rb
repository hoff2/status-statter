require_relative 'spec_helper'
require 'status_statter/trackers/average_over_time'
require 'timecop'

describe AverageOverTime do

  let(:abt){ AverageOverTime.new }

  it "averages tweets per second" do
    start = Time.now
    Timecop.freeze(start)
    abt.start
    35.times { abt.record(:tweet) }
    Timecop.freeze(start + 5)
    abt.stop
    abt.report[:average_per_second].should == 7
  end

end
