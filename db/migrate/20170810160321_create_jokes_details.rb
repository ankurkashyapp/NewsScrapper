class CreateJokesDetails < ActiveRecord::Migration[5.0]
  def change
    create_table :jokes_details do |t|
    	t.string :image
    	t.text :joke_content
    	t.references :jokes_list, index: true, foreign_key: true
      	t.timestamps null: false
    end
    	execute "ALTER table jokes_details ADD UNIQUE(jokes_list_id)"
  end
end
