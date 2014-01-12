class StatusStatter

  # optional arguments:
  # 1. which streaming API method to use -- its name as a symbol,
  #    or an array of the method name symbol + arguments. Examples:
  #    :firehose
  #    [ :track, 'bacon', 'mom' ]
  # 2. API client. If none given, a Tweetstream::Client is created
  #    by default.
  def initialize(message = :sample, _client = false)
    @client = _client || tweetstream_client
    @tracker_classes = []
    @message = message
  end

  attr_reader :client, :message
  attr_reader :start_time, :stop_time

  def tweetstream_client
    require_relative 'status_statter/config'
    require 'tweetstream'
    TweetStream.configure do |config|
      config.consumer_key       = StatusStatter::Config::CONSUMER_KEY
      config.consumer_secret    = StatusStatter::Config::CONSUMER_SECRET
      config.oauth_token        = StatusStatter::Config::OAUTH_TOKEN
      config.oauth_token_secret = StatusStatter::Config::OAUTH_SECRET
      config.auth_method        = :oauth
    end
    TweetStream::Client.new
  end

  # Add classes for objects that will be used to track stats. An
  # instance of each class added in this way will be created Each
  # should respond to #initialize, #record(status), and #report
  def register(*tracker)
    @tracker_classes += tracker
  end

  def initialize_trackers
    @trackers = @tracker_classes.map(&:new)
  end

  # Start up the StatusStatter.
  def run
    initialize_trackers
    @start_time = Time.now
    @client.send(*@message) do |status|
      puts "#{status.text}" if $DEBUG
      @trackers.each do |t|
        t.record(status)
      end
    end
  end

  # Stop the StatusStatter
  def stop
    @client.stop
    @stop_time = Time.now
  end

  # Collect results from trackers
  # Can probably be called while running for in-progress reports too
  def results
    @trackers.map(&:report)
  end
end
