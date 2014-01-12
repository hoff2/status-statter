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

  it "averages tweets per minute" do
    start = Time.now
    Timecop.freeze(start)
    abt.start
    35.times { abt.record(:tweet) }
    Timecop.freeze(start + 5*60)
    abt.stop
    abt.report[:average_per_minute].should == 7
  end

  it "averages tweets per hour" do
    start = Time.now
    Timecop.freeze(start)
    abt.start
    35.times { abt.record(:tweet) }
    Timecop.freeze(start + 5*60*60)
    abt.stop
    abt.report[:average_per_hour].should == 7
  end

end
