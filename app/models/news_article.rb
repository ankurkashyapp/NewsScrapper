class NewsArticle < ApplicationRecord
	belongs_to :news_feed

	UP_SAHARANPUR_SINGLE_NEWS_URL = "http://www.jagran.com/uttar-pradesh/saharanpur-.html"

	def self.updateNewsArticles
		feeds = NewsFeed.where("id NOT IN (?)", NewsArticle.select(:news_feed_id))
		feeds.each do |feed|
			puts "*******"
			puts feed[:id]
			page = Nokogiri::HTML(open(getSingleNewsUrl("Saharanpur", feed[:id])))
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
			begin
				NewsArticle.create(title: @articleTitle, image: @articleImage, date: @date, summary: @articleText, news_feed_id: feed[:id])
				rescue ActiveRecord::RecordNotUnique => e
			end			
		end

	end

	private
		def self.getSingleNewsUrl(city, newsId)
			if city == "Saharanpur"
				articleId = newsId.to_s
				@city_single_news_url = String.new(UP_SAHARANPUR_SINGLE_NEWS_URL)
				@city_single_news_url = @city_single_news_url.insert(-6, articleId)
			end
			puts @city_single_news_url
			return @city_single_news_url
		end
end