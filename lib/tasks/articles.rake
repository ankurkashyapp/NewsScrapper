namespace :articles do
	desc "update news articles"
  task update_articles: :environment do
  	NewsArticle.updateNewsArticles
  end
end