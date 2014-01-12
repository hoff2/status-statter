class StatusStatter

  # optional arguments:
  # 1. which streaming API method to use -- its name as a symbol,
  #    or an array of the method name symbol + arguments (suitable
  #    for being passed to #send). Examples:
  #      :firehose
  #      [ :track, 'bacon', 'mom' ]
  # 2. API client. If none given, a Tweetstream::Client is created
  #    by default.
  def initialize(message = :sample, _client = false)
    @client = _client || tweetstream_client
    @tracker_classes = []
    @method = message
  end

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

  # Add a class for an object that will be used to track stats.
  # An instance of each class added in this way will be created
  # Each should respond to #initialize, #record(status), and #report
  def register(tracker)
    @tracker_classes << tracker
  end

  # Start up the status_statter. When stopped with Control-C/SIGINT,
  # reports will be collected from each of the tracker objects
  def run
    trackers = @tracker_classes.map(&:new)
    puts "Here we go (Ctrl-C to stop)..."
    @start_time = Time.now
    @client.send(*@method) do |status|
      puts "#{status.text}" if $DEBUG
      trackers.each do |t|
        t.record(status)
      end
    end
  rescue SystemExit, Interrupt
    @stop_time = Time.now
    @results = trackers.map(&:report)
  end

  # Get results from trackers after #run has been stopped
  attr_reader :results

end
