require_relative 'spec_helper'
require 'status_statter/trackers/average_over_time'
require 'timecop'

describe AverageOverTime do

  subject{ AverageOverTime.new }

  it "averages tweets per second" do
    start = Time.now
    Timecop.freeze(start)
    subject.start
    35.times { subject.record(:tweet) }
    Timecop.freeze(start + 5)
    subject.stop
    subject.report[:average_per_second].should == 7
  end

  it "averages tweets per minute" do
    start = Time.now
    Timecop.freeze(start)
    subject.start
    35.times { subject.record(:tweet) }
    Timecop.freeze(start + 5*60)
    subject.stop
    subject.report[:average_per_minute].should == 7
  end

  it "averages tweets per hour" do
    start = Time.now
    Timecop.freeze(start)
    subject.start
    35.times { subject.record(:tweet) }
    Timecop.freeze(start + 5*60*60)
    subject.stop
    subject.report[:average_per_hour].should == 7
  end

end
