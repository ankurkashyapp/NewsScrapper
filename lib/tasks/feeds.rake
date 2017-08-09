namespace :feeds do
	desc "update news feeds"
  task update_feeds: :environment do
  	NewsFeed.updateNewsFeeds
  end
end