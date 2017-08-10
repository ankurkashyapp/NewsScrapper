class JokesList < ApplicationRecord
	has_one :jokes_detail
	paginates_per 20

	JOKES_URL = "http://www.jagran.com/hindi-jokes-page2.html"
	NEWS_ROOT_URL = "http://www.jagran.com"

	def self.updateJokesList
		@user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_0) AppleWebKit/535.2 (KHTML, like Gecko) Chrome/15.0.854.0 Safari/535.2"
		page = Nokogiri::HTML(open(JOKES_URL, 'User-Agent' => @user_agent))
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
	end
end
