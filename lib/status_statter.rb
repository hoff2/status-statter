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
  end

  def run(&blk)
    @client.sample(&blk)
  end

end
