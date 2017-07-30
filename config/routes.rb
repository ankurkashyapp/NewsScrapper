Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
  	namespace :v1 do

  		get 'news_feeds' => 'news_feeds#show_all'
  		get 'news'		 => 'news_feeds#single_news'
  		get 'get_latest_app' => 'news_feeds#app_version'

  	end
  end

end
