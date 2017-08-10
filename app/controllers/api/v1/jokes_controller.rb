class Api::V1::JokesController < ApplicationController
	
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
end
