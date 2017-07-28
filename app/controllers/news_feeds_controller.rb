class Api::V1::NewsFeedsController < ApplicationController

	require 'rubygems'
	require 'nokogiri'
	require 'open-uri'

	NEWS_ROOT_URL = "http://www.jagran.com"
	UP_SAHARANPUR_URL = "http://www.jagran.com/local/uttar-pradesh_saharanpur-news-hindi-page.html"
	RAJASTHAN_JAIPUR_URL = "http://www.jagran.com/local/rajasthan_jaipur-news-hindi.html"

	def show_all
		page = Nokogiri::HTML(open(getCityUrl(params[:city], params[:page])))
		@articlesList = page.css('.listing').css('li')
		@articles = [ ]
		@articlesList.each do |article|
			@newsRootUrl = String.new(NEWS_ROOT_URL)
			@title = article.css('h2').css('a').first['title']
			begin
				@image = article.css('a').css('img').first['src']
				rescue Exception
					@image = nil
			end
			@link = @newsRootUrl.concat(article.css('a').first['href'])
			article.css('p').search("a").remove
			@summary = article.css('p').first.text.strip
			@article_summary = {"title" => @title, "summary" => @summary, "image" => @image, "link" => @link}
			@articles << @article_summary
		end

		render json: {"message": "User created successfully", "content": @articles}, status: 201
	end

	def single_news
		page = Nokogiri::HTML(open("http://www.jagran.com/uttar-pradesh/saharanpur-16451282.html"))
		@wholeArticle = page.css('.articaldetail')
		@articleTitle = @wholeArticle.css('.title')
		@articleImage = @wholeArticle.css('.articaltext').css('.article-content').css('.boxgrid').css('img').first['src']
		@articleTextLines = @wholeArticle.css('.articaltext').css('.article-content').css('p')
		@articleText = ""
		@articleTextLines.each do |articleLine|
			@articaltext.concat(articleLine.text.strip)
		end

		render json: {"title": @articleTitle, "image": @articleImage, "content": @articaltext}
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
