class Api::V1::NewsFeedsController < ApplicationController

	require 'rubygems'
	require 'nokogiri'
	require 'open-uri'

	NEWS_ROOT_URL = "http://www.jagran.com"
	UP_SAHARANPUR_URL = "http://www.jagran.com/local/uttar-pradesh_saharanpur-news-hindi-page.html"
	UP_SAHARANPUR_SINGLE_NEWS_URL = "http://www.jagran.com/uttar-pradesh/saharanpur-.html"
	JOKES_URL = "http://www.jagran.com/hindi-jokes-page.html"
	JOKES_SINGLE_URL = "http://www.jagran.com/jokes/general-funny-jokes-in-hindi-.html"

	RAJASTHAN_JAIPUR_URL = "http://www.jagran.com/local/rajasthan_jaipur-news-hindi.html"

	THOUGHT_URL = "http://www.achhikhabar.com/2012/01/01/101-inspirational-motivational-quotes-in-hindi/"

	def show_all
		page = Nokogiri::HTML(open(getCityUrl(params[:city], params[:page])))
		@articlesList = page.css('.listing').css('li')
		@articles = [ ]
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
			@article_summary = {"title" => @title, "summary" => @summary, "image" => @image, "link" => @link, "date" => @date}
			@articles << @article_summary
		end

		render json: {"message": "User created successfully", "content": @articles}, status: 201
	end

	def single_news
		@city = params[:city]
		@newsId = params[:news_id]
		page = Nokogiri::HTML(open(getSingleNewsUrl(@city, @newsId)))
		@wholeArticle = page.css('.articaldetail')

		@articleTitle = @wholeArticle.css('.title').css('h1').text.strip

		@date = @wholeArticle.css('.title').css('.grayrow').first.css('span').text
		@date = @date[/#{"Updated Date"}(.*?)#{"(IST)"}/m, 1].strip[1, @date.rindex('(')-61]
		@articleImage = @wholeArticle.css('.articaltext').css('.article-content').css('.boxgrid').css('img').first['src']
		@articleTextLines = @wholeArticle.css('.articaltext').css('.article-content').css('p')
		@articleText = String.new
		@articleTextLines.each do |articleLine|
			@articleText = @articleText.concat(articleLine.text)
		end

		render json: {"title": @articleTitle, "image": @articleImage, "date": @date, "summary": @articleText}
	end

	def app_version
		appVersion = AppVersion.where("app_name in (?) and latest_version in (?)", params[:app_name], params[:installed_version])
		if appVersion.size>0
			@message_type = "NORMAL"
		else
			appVersion = AppVersion.where("app_name in (?)", params[:app_name])
			@message_type = "ALERT"
		end
		render json: {"message_type": @message_type, "thought": getThoughtOfDay, "app_version": appVersion}
	end

	def all_jokes
		@page = params[:page]
		page = Nokogiri::HTML(open(getJokesUrl(@page)))
		jokes = page.css('.mpagearticlelist').css('.articletxtCon')
		@jokesList = [ ]
		jokes.each do |joke|
			@newsRootUrl = String.new(NEWS_ROOT_URL)
			joke = joke.css('.ajax')
			@title = joke.css('h2').first.text.strip
			@link = @newsRootUrl.concat(joke.first['href'])
			@image = joke.css('.smiley-icon').css('img').first['src']

			@jokesList << {"title" => @title, "link" => @link, "image" => @image}
		end
		render json: @jokesList, status: 201
	end

	def single_joke
		@jokeId = params[:joke_id]
		page = Nokogiri::HTML(open(singleJokeUrl(@jokeId)))
		puts singleJokeUrl(@jokeId)
		@jokeText = page.css('.joketext').first.css('p')
		@image = page.css('.joketext').css('.jokeimg').css('img').first['src']
		@fullJoke = String.new("")
		@jokeText.each do |text1|
			@fullJoke = @fullJoke + text1.text
		end
		render json: {"image": @image, "joke_content": @fullJoke}
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

		def getSingleNewsUrl(city, newsId)
			if city == "Saharanpur"
				@city_single_news_url = String.new(UP_SAHARANPUR_SINGLE_NEWS_URL)
				@city_single_news_url = @city_single_news_url.insert(-6, newsId)
			end
			puts @city_single_news_url
			return @city_single_news_url
		end

		def getThoughtOfDay
			page = Nokogiri::HTML(open(THOUGHT_URL))
			@thoughts = page.css('.entry-content').css('p')
			@thoughts_filtered = []
			i = 1
			while i<@thoughts.size && i<60 do
				@thoughts[i].search('span').remove
				@thoughts_filtered << @thoughts[i].text.strip
				#puts @thoughts[i].text.strip
				i = i+2
			end
			@randomNo = rand(@thoughts_filtered.size)
			@thoughts = page.css('.entry-content').css('h5')
			#return @thoughts_filtered[]
			puts @thoughts_filtered[@randomNo]
			return {"thought_of_day": @thoughts_filtered[@randomNo], "author": @thoughts[@randomNo-1].text.strip}
		end

		def getJokesUrl(page)
			if page == "1"
				@jokesUrl = String.new("http://www.jagran.com/hindi-jokes.html")
			else
				@jokesUrl = String.new(JOKES_URL)
				@jokesUrl = @jokesUrl.insert(-6, page)
			end
			return @jokesUrl
		end

		def singleJokeUrl(jokeId)
			@jokeUrl = String.new(JOKES_SINGLE_URL)
			@jokeUrl = @jokeUrl.insert(-6, jokeId)
		end

end
