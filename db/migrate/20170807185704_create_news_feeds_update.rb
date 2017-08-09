class CreateNewsFeedsUpdate < ActiveRecord::Migration[5.0]
  def change
  	create_table :news_feeds do |t|
      t.text :title
      t.text :summary
      t.string :image
      t.string :link
      t.string :date
      t.string :city
      t.timestamps null: false
  	end
  end
end
