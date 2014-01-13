require_relative 'spec_helper'
require 'status_statter/trackers/top_hashtags'

describe TopHashtags do

  def tweet_with_hashtags(*tags)
    tweet = double("tweet")
    hashtags = tags.map!{ |tag|
      hashtag = double("hashtag")
      hashtag.stub(text: tag)
      hashtag
    }
    tweet.stub(hashtags: hashtags)
    tweet
  end

  subject{ TopHashtags.new }

  it "takes note of hashtags in tweets" do
    hashtags = ['SabadoDeGanarSeguidores', 'SIGUEMEYTESIGO']
    tweet = tweet_with_hashtags(*hashtags)
    subject.start
    subject.record(tweet)
    subject.report.map{|i| i[:text]}.should match_array(hashtags)
  end

end
