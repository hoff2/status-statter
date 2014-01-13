# TODO: subclass something that provides empty method defs
class TopHashtags

  def initialize(how_many=10)
    @how_many = how_many
  end

  def start
    @counts = Hash.new{|h,k| h[k] = 0}
  end

  def record(status)
    status.hashtags.map(&:text).each do |hashtag|
      @counts[hashtag] += 1
    end
  end

  def stop; end

  def report
    @counts.map{|k, v| { text: k, count: v }}.
      sort{|a, b| a[:count] <=> b[:count]}.
      first(@how_many)
  end
end
