class NewsFeed < ApplicationRecord
	has_one :news_article
	paginates_per 12
	require 'rubygems'
	require 'nokogiri'
	require 'open-uri'

	NEWS_ROOT_URL = "http://www.jagran.com"
	UP_SAHARANPUR_URL = "http://www.jagran.com/local/uttar-pradesh_saharanpur-news-hindi-page.html"

	def self.updateNewsFeeds
		page = Nokogiri::HTML(open("http://www.jagran.com/local/uttar-pradesh_saharanpur-news-hindi-page1.html"))
		@articlesList = page.css('.listing').css('li')
		@articlesList.each do |article|
			@newsRootUrl = String.new(NEWS_ROOT_URL)
			@title = article.css('h2').css('a').first['title']
			@date = article.css('.date-cat').first.text.strip
			@date = @date[/#{"on:"}(.*?)#{"(IST)"}/m, 1].strip[1, @date.rindex('(')-13]
			begin
				@image = article.css('a').css('img').first['src']
				rescue Exception
					@image = nil
			end
			@link = @newsRootUrl.concat(article.css('a').first['href'])
			article.css('p').search("a").remove
			@summary = article.css('p').first.text.strip
			@news_id = @link[@link.rindex('-')+1, @link.rindex('.')]
			begin
				NewsFeed.create(id: @news_id, title: @title, summary: @summary, image: @image, link: @link, date: @date, city: "Saharanpur")
				rescue ActiveRecord::RecordNotUnique
			end
		end
		
	end

	private
		def getCityUrl(city, page)

			if city == "Saharanpur"
				@city_url = String.new(UP_SAHARANPUR_URL)
				@url = @city_url.insert(-6, page)
			else
				@city_url = String.new(RAJASTHAN_JAIPUR_URL)
				@url = @city_url.insert(-6, page)
			end
			puts @url
			return @url
		end
end
