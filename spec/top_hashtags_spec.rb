require_relative 'spec_helper'
require 'status_statter/trackers/top_hashtags'
require 'faker'
I18n.enforce_available_locales = false # to get rid of warning from Faker

describe TopHashtags do

  def tweet_with(*tags)
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

  it "takes note of hashtags in a tweet" do
    hashtags = 5.times.collect{ Faker::Lorem.word }
    tweet = tweet_with(*hashtags)
    subject.start
    subject.record(tweet)
    expect(subject.report.map{|i| i[:text]}).to match_array(hashtags)
  end

  it "will report top 10 hashtags by default" do
    subject.start
    1000.times{ subject.record(tweet_with(Faker::Lorem.word)) }
    subject.report.count.should == 10
  end

  it "will report them most-seen first" do
    hashtags = ([2, 10, 5].zip(3.times.collect{ Faker::Lorem.word })).
      map{|a| [a[1]]*a[0]}.flatten.shuffle
    subject.start
    hashtags.each do |hashtag|
      subject.record(tweet_with(hashtag))
    end
    counts = subject.report.map{|i| i[:count]}
    expect(counts).to eq([10, 5, 2])
  end

end
