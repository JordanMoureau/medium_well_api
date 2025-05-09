require 'open-uri'
require 'nokogiri'

class MediumFeedParser
    def self.fetch_articles(profile)
      url = "https://medium.com/feed/#{profile}"
      xml = URI.open(url).read
      doc = Nokogiri::XML(xml)
      items = doc.xpath('//item')
  
      items.map do |item|
        content = item.at_xpath('content:encoded')&.text
  
        {
          title: item.at_xpath('title')&.text,
          description: sanitize_description(content),
          date: item.at_xpath('pubDate')&.text,
          url: item.at_xpath('link')&.text,
          tags: item.xpath('category').map(&:text)
        }
      end
    end
  
    private
  
    def self.sanitize_description(content)
      return '' if content.blank?
  
      doc = Nokogiri::HTML(content)
      first_paragraph = doc.at('p')&.text || ''
      first_paragraph.truncate(250) # Adjust length as needed
    end
  end
  