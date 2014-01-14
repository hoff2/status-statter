require 'uri'

class Urls < StatusStatter::Tracker

  PHOTO_DOMAINS = %w( instagram.com pic.twitter.com )

  def initialize(how_many=10)
    @how_many = how_many
  end

  def start
    @domains_seen = Hash.new{|h, k| h[k] = 0}
    @total = 0
    @with_urls = 0
    @with_photo_urls = 0
  end

  def record(status)
    @total += 1
    unless status.urls.empty?
      @with_urls += 1
      domains = status.urls.map{ |u|
        URI.parse(u.extended_url).host.gsub(/^www\./, '') }
      domains.each do |domain|
        @domains_seen[domain] += 1
      end
      @with_photo_urls += 1 unless (domains & PHOTO_DOMAINS).empty?
    end
  end

  def report
    { domains: @domains_seen.map{|k, v| { domain: k, count: v }}.
               sort{|a, b| b[:count] <=> a[:count]}.first(@how_many),

    }
  end

end