class Api::V1::NewsFeedsController < ApplicationController

	require 'rubygems'
	require 'nokogiri'
	require 'open-uri'

	NEWS_ROOT_URL = "http://www.jagran.com"
	UP_SAHARANPUR_URL = "http://www.jagran.com/local/uttar-pradesh_saharanpur-news-hindi-page.html"

	def show_all
		page = Nokogiri::HTML(open(getCityUrl(params[:city], params[:page])))
		@articlesList = [ ]
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

	private
		def getCityUrl(city, page)

			if city == "Saharanpur"
				@city_url = String.new(UP_SAHARANPUR_URL)
				@url = @city_url.insert(-6, page)
			end
			puts @url
			return @url
		end

end
