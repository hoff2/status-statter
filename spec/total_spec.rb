require_relative 'spec_helper'
require 'status_statter/trackers/total'

describe Total do

  it "counts statuses received" do
    [1, 14, 352].each do |n|
      subject = Total.new
      n.times{ subject.record(:tweet) }
      subject.report[:total].should == n
    end
  end

end
