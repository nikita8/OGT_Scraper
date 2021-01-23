require 'open-uri'

module UrlScraper
  def self.canonical_url(url)
    doc = Nokogiri::HTML(URI.open(url))
    canonical_url = (doc.at('link[rel="canonical"]') || {})['href'] || doc.css("meta[property='og:url']")&.first&.attributes&.dig("content")&.value
    canonical_url || url
  end

  def self.meta_info(url)
    parser = Parser.new(url)
    images = parser.page.css("meta[property='og:image']").each_with_index.map do |image, i| 
      { 
        url: image.attributes["content"].value,
        type: parser.call("image:type", i),
        width: parser.call("image:width", i),
        height: parser.call("image:height", i),
        alt: parser.call("image:alt", i)
      }
    end
    {
      type: parser.call("type"),
      title: parser.call("title"),
      images: images
    }
  end
end

class Parser
  attr_accessor :page

  def initialize(url)
    @page = Nokogiri::HTML(URI.open(url))
  end

  def call(tag, index=0)
    @page.css("meta[property='og:#{tag}']")[index]&.attributes&.dig("content")&.value
  end
end


