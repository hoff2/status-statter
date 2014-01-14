require_relative 'spec_helper'
require 'status_statter/trackers/urls'
require 'faker'
I18n.enforce_available_locales = false # to get rid of warning from Faker

describe Urls do

  def tweet_with(*urls)
    tweet = double("tweet")
    urlobjs = urls.map!{ |url|
      urlobj = double("url")
      urlobj.stub(expanded_url: url)
      urlobj
    }
    tweet.stub(urls: urlobjs)
    tweet
  end

  subject{ Urls.new }

  it "will report top 10 urls by default" do
    subject.start
    1000.times{ subject.record(tweet_with(Faker::Internet.url)) }
    subject.report[:domains].count.should == 10
  end

  it "will report them most-seen first" do
    urls = ([2, 10, 5].zip(3.times.collect{ Faker::Internet.url })).
      map{|a| [a[1]]*a[0]}.flatten.shuffle
    subject.start
    urls.each do |url|
      subject.record(tweet_with(url))
    end
    counts = subject.report[:domains].map{|i| i[:count]}
    expect(counts).to eq([10, 5, 2])
  end

  it "will count how many statuses have urls" do
    subject.start
    7.times{ subject.record(tweet_with(Faker::Internet.url)) }
    # make sure tweets with multiple URLs are still only counted once
    3.times{ subject.record(tweet_with(Faker::Internet.url,
                                       Faker::Internet.url)) }
    30.times{ subject.record(tweet_with()) } # no urls
    subject.report[:with_urls].should == 10
    subject.report[:with_urls_pct].should == 25
  end

  it "will count how many statuses have photo urls" do
    subject.start
    subject.record(tweet_with('https://pic.twitter.com/Sk3OyxDbFr'))
    5.times{ subject.record(tweet_with(Faker::Internet.url)) }
    subject.record(tweet_with('http://instagram.com/p/jC1-sOHkG6/#'))
    20.times{ subject.record(tweet_with()) } # no urls
    subject.record(tweet_with('http://instagram.com/p/iOsSuXnkDo/#'))
    2.times{ subject.record(tweet_with(Faker::Internet.url,
                                       Faker::Internet.url)) }
    subject.report[:with_photo].should == 3
    subject.report[:with_photo_pct].should == 10
  end
end
