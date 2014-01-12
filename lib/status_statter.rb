require_relative 'status_statter/config'
require 'tweetstream'

class StatusStatter

  def initialize
    TweetStream.configure do |config|
      config.consumer_key       = StatusStatter::Config::CONSUMER_KEY
      config.consumer_secret    = StatusStatter::Config::CONSUMER_SECRET
      config.oauth_token        = StatusStatter::Config::OAUTH_TOKEN
      config.oauth_token_secret = StatusStatter::Config::OAUTH_SECRET
      config.auth_method        = :oauth
    end
    @client = TweetStream::Client.new
    @tracker_classes = []
    @method = StatusStatter::Config::API_MESSAGE
  end

  def register(tracker)
    @tracker_classes << tracker
  end

  def run
    trackers = @tracker_classes.map(&:new)
    puts "Here we go..."
    @start_time = Time.now
    @client.send(*@method) do |status|
      puts "#{status.text}" if $DEBUG
      trackers.each do |t|
        t.record(status)
      end
    end
  rescue SystemExit, Interrupt
    @stop_time = Time.now
    trackers.each do |t|
      puts t.report
    end
    exit
  end

end
