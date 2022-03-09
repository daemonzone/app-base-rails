base_url = "http://#{request.host_with_port}"
xml.instruct! :xml, :version=>'1.0'
xml.tag! 'urlset', 'xmlns' => 'http://www.sitemaps.org/schemas/sitemap/0.9' do
  xml.url{
      xml.loc("https://www.avqservizi.it")
      xml.changefreq("weekly")
      xml.priority(0.5)
  }

  @categories.each do |cat|
    xml.url {
      xml.loc root_url + 'servizi/' + cat.key
      xml.changefreq("monthly")
      xml.priority(0.5)
    }
  end

  @users.each do |user|
    xml.url {
      xml.loc root_url + 'aziende/' + (user.public_url.nil? ? '' : user.public_url)
      xml.lastmod user.updated_at.strftime("%F")
      xml.changefreq("daily")
      xml.priority(1.0)
    }
  end

end