class Api::V1::JokesController < ApplicationController
	
	JOKES_URL = "http://www.jagran.com/hindi-jokes-page1.html"
	JOKES_SINGLE_URL = "http://www.jagran.com/jokes/general-funny-jokes-in-hindi-.html"
	NEWS_ROOT_URL = "http://www.jagran.com"

	def all_jokes
		@page = params[:page]
		jokes = JokesList.all.order(id: :DESC).page params[:page]
		render json: jokes, status: 200
	end

	def single_joke
		@jokeId = params[:joke_id]
		joke = JokesDetail.where("jokes_list_id = (?)", @jokeId).first
		render json: joke, status: 200
	end

	def update_jokes
		@user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_0) AppleWebKit/535.2 (KHTML, like Gecko) Chrome/15.0.854.0 Safari/535.2"
		page = Nokogiri::HTML(open(JOKES_URL, :proxy => "http://".concat(params[:ip]).concat(":").concat(params[:port]), 'User-Agent' => @user_agent))
		jokes = page.css('.mpagearticlelist').css('.articletxtCon')
		jokes.each do |joke|
			@newsRootUrl = String.new(NEWS_ROOT_URL)
			joke = joke.css('.ajax')
			@title = joke.css('h2').first.text.strip
			@link = @newsRootUrl.concat(joke.first['href'])
			@image = joke.css('.smiley-icon').css('img').first['src']
			@joke_id = @link[@link.rindex('-')+1, @link.rindex('.')]
			begin
				JokesList.create(id: @joke_id, title: @title, link: @link, image: @image, joke_type: "All Jokes")
				rescue ActiveRecord::RecordNotUnique => e
			end
		end

		render json: {"message": "Jokes List updated successfully"}
	end

	def update_jokes_details
		@user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_0) AppleWebKit/535.2 (KHTML, like Gecko) Chrome/15.0.854.0 Safari/535.2"
		jokesList = JokesList.where("id NOT IN (?)", JokesDetail.select(:jokes_list_id))
		jokesList.each do |joke|
			@jokeId = joke[:id]
			page = Nokogiri::HTML(open(singleJokeUrl(@jokeId), :proxy => "http://".concat(params[:ip]).concat(":").concat(params[:port]), 'User-Agent' => @user_agent))
			puts singleJokeUrl(@jokeId)
			@jokeText = page.css('.joketext').first.css('p')
			@image = page.css('.joketext').css('.jokeimg').css('img').first['src']
			@fullJoke = String.new("")
			@jokeText.each do |text1|
				@fullJoke = @fullJoke + text1.text
			end
			begin
				JokesDetail.create(image: @image, joke_content: @fullJoke, jokes_list_id: @jokeId)
				rescue ActiveRecord::RecordNotUnique => e
			end
		end
		render json: {"message": "Jokes Details updated successfully"}
	end

	private
		def singleJokeUrl(jokeId)
			@jokeUrl = String.new(JOKES_SINGLE_URL)
			@jokeUrl = @jokeUrl.insert(-6, jokeId.to_s)
		end
end
