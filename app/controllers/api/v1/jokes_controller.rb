class Api::V1::JokesController < ApplicationController
	
	def all_jokes
		@page = params[:page]
		jokes = JokesList.all.order(id: :DESC).page params[:page]
		render json: jokes, status: 200
	end
end
