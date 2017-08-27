Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
  	namespace :v1 do

  		get 'news_feeds' => 'news_feeds#show_all'
  		get 'news'		 => 'news_feeds#single_news'
  		get 'get_latest_app' => 'news_feeds#app_version'
  		get 'jokes' => 'jokes#all_jokes'
  		get 'single_joke' => 'jokes#single_joke'
      get 'update_news' => 'news_feeds#update_feeds'
      get 'update_articles' => 'news_feeds#update_articles'
      get 'update_jokes' => 'jokes#update_jokes'
      get 'update_jokes_details' => 'jokes#update_jokes_details'
  	end
  end

end
