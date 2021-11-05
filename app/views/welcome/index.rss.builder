xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Otodom RSS"
    xml.link welcome_url(format: :rss)

    @data.each do |offer|
      xml.item do
        xml.title offer.fetch(:title)
        xml.link offer.fetch(:url)
        xml.description offer.fetch(:description)
        xml.enclosure url: offer.fetch(:image), type: 'image/webp'
        xml.guid offer.fetch(:url)
        # xml.pubDate
        xml.source welcome_url(format: :rss)
      end
    end
  end
end
