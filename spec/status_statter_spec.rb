require_relative 'spec_helper'

describe StatusStatter do

  it "accepts an API method as a constructor argument" do
    statter = StatusStatter.new(:message)
    expect(statter.message).to eq(:message)
  end

  it "accepts the API client as a constructor argument" do
    client = double('client')
    statter = StatusStatter.new(:ignored, client)
    expect(statter.client).to eq(client)
  end

  it "uses the given method on the given client when run" do
    client = double('client')
    client.should_receive :message
    statter = StatusStatter.new(:message, client)
    statter.run
  end

  it "can accept arguments to pass to that method too" do
    client = double('client')
    client.should_receive(:message).with(:first, :second)
    statter = StatusStatter.new([:message, :first, :second], client)
    statter.run
  end

  it "registers trackers by class" do
    client = double('client').as_null_object
    tracker1 = double('TrackerClass1')
    tracker2 = double('TrackerClass2')
    statter = StatusStatter.new(:message, client)
    statter.register(tracker1, tracker2)
    tracker1.should_receive(:new)
    tracker2.should_receive(:new)
    statter.run
  end

  class FakeClient
    def api_method(&blk)
      @handler = blk
    end
    def receive_status(status)
      @handler.call(status)
    end
    def report; :report; end
    def method_missing; :ignore; end
  end

  it "notifies tracker objects of statuses received" do
    client = FakeClient.new
    statter = StatusStatter.new(:api_method, client)
    tracker_class = double('TrackerClass')
    tracker = double('tracker')
    tracker_class.should_receive(:new).and_return(tracker)
    statter.register(tracker_class)
    tracker.should_receive(:record).with(:tweet)
    statter.run
    client.receive_status(:tweet)
  end
end
