class JokesDetail < ApplicationRecord
	belongs_to :jokes_list

	JOKES_SINGLE_URL = "http://www.jagran.com/jokes/general-funny-jokes-in-hindi-.html"

	def self.updateJokesDetails
		@user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_0) AppleWebKit/535.2 (KHTML, like Gecko) Chrome/15.0.854.0 Safari/535.2"
		jokesList = JokesList.where("id NOT IN (?)", JokesDetail.select(:jokes_list_id))
		jokesList.each do |joke|
			@jokeId = joke[:id]
			page = Nokogiri::HTML(open(singleJokeUrl(@jokeId), 'User-Agent' => @user_agent))
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
		
	end

	private
		def self.singleJokeUrl(jokeId)
			@jokeUrl = String.new(JOKES_SINGLE_URL)
			@jokeUrl = @jokeUrl.insert(-6, jokeId.to_s)
		end
end
