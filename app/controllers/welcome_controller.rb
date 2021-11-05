require 'nokogiri'
require 'uri'
require 'open-uri'

class WelcomeController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.rss { parse; render :layout => false }
    end
  end

  private

  def parse
    url = "https://www.otodom.pl/pl/oferty/wynajem/mieszkanie/warszawa?roomsNumber=%5BTHREE%2CFOUR%2CFIVE%2CSIX%5D&areaMin=70&distanceRadius=5&market=ALL&page=1&limit=72&locations=%5Bcities_6-26%5D&by=DEFAULT&direction=DESC&lang=pl&searchingCriteria=wynajem&searchingCriteria=mieszkanie&searchingCriteria=cala-polska"
    text = URI.open(url).read
    @data = Nokogiri::HTML.parse(text).css('div[data-cy="search.listing"] li').map { |x| x.at_css('p') }.map {|x| x&.text }.compact
  end
end
