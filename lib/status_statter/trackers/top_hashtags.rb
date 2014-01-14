class TopHashtags < StatusStatter::Tracker

  def initialize(how_many=10)
    @how_many = how_many
  end

  def start
    @hashtaghash = Hash.new{|h,k| h[k] = 0}
  end

  def record(status)
    status.hashtags.map(&:text).each do |hashtag|
      @hashtaghash[hashtag] += 1
    end
  end

  def report
    @hashtaghash.map{|k, v| { text: k, count: v }}.
      sort{|a, b| b[:count] <=> a[:count]}.
      first(@how_many)
  end

end
