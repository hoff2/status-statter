require_relative 'spec_helper'
require 'status_statter/trackers/urls'
require 'faker'
I18n.enforce_available_locales = false # to get rid of warning from Faker

describe Urls do

  def tweet_with(*urls)
    tweet = double("tweet")
    urlobjs = urls.map!{ |url|
      urlobj = double("url")
      urlobj.stub(extended_url: url)
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
end
