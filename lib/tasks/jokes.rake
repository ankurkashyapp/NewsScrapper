namespace :jokes do
	desc "Task to update jokes"

	task update_jokes: :environment do
		JokesList.updateJokesList
	end

	task update_jokes_details: :environment do
		JokesDetail.updateJokesDetails
	end
end