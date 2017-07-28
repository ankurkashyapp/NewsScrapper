class Api::V1::UsersController < ApplicationController
	require 'rubygems'
	require 'nokogiri'
	require 'open-uri'

	def show_all
		#@user = User.find(params[:id])
		#@posts = Post.all
		
		#@listOfPosts = [ ]
		#@listOfPosts << @user
		#@posts.each do |post|
		#	@listOfPosts << post
		#end
		#@content = { "posts": @listOfPosts }
		page = Nokogiri::HTML(open("http://www.jagran.com/local/uttar-pradesh_saharanpur-news-hindi.html"))
		@articlesList = [ ]
		@articlesList = page.css('.listing').css('li')
		@articles = [ ]
		@articlesList.each do |article|
			
			@title = article.css('h2').css('a').first['title']
			@image = article.css('a').css('img').first['src']
			@link = article.css('a').first['href']
			article.css('p').search("a").remove
			@summary = article.css('p').first.text.strip
			@article_summary = {"title" => @title, "summary" => @summary, "image" => @image, "link" => @link}
			@articles << @article_summary
		end
		#page = Nokogiri::HTML(open("http://www.jagran.com/uttar-pradesh/saharanpur-people-leave-stray-dogs-in-municipal-commissioner-office-in-saharanpur-16436407.html"))
		#@wholeArticle = page.css('.article-content').first
		#@content = ""
		#@wholeArticle.css('p').each do |para|
		#	@content =  @content + para.text
		#end

		render json: {"message": "User created successfully", "content": @articles}, status: 201
	end
end
