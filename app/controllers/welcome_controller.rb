require 'nokogiri'
require 'uri'
require 'open-uri'

class WelcomeController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.rss do
        parse
        render layout: false
      end
    end
  end

  private

  def parse
    url = 'https://www.otodom.pl/pl/oferty/wynajem/mieszkanie/warszawa?roomsNumber=%5BTHREE%2CFOUR%2CFIVE%2CSIX%5D&priceMax=5000&areaMin=70&distanceRadius=5&market=ALL&page=1&limit=72&locations=%5Bcities_6-26%5D&by=DEFAULT&direction=DESC'
    text = URI.open(url).read
    # text = File.read('../ototo/pages/1.html')
    @data = Nokogiri::HTML.parse(text).css('div[data-cy="search.listing"] li').map do |x|
      title = x.at_css('h3')&.text
      next unless title

      link = 'https://www.otodom.pl' + x.at_css('a[data-cy="listing-item-link"]')['href']
      {
        title: title,
        url: link,
        description: x.css('p span').map(&:text).join(' ') + x.to_s[%r{\d+.(zł/mc|EUR|€|zł)}],
        image: x.css('picture source').last['srcset'],
        # pubDate: ,
        guid: link
      }
    end.compact
    p @data
  end
end
