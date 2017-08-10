class CreateJokesList < ActiveRecord::Migration[5.0]
  def change
    create_table :jokes_lists do |t|
    	t.string :title
    	t.string :image
    	t.string :link
    	t.string :joke_type
    	t.timestamps null: false
    end
  end
end
