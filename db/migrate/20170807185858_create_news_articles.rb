class CreateNewsArticles < ActiveRecord::Migration[5.0]
  def change
  	create_table :news_articles do |t|
      t.text :title
      t.string :image
      t.string :date
      t.text :summary
      t.references :news_feed, index: true, foreign_key: true
      t.timestamps null: false
  	end
    execute "ALTER table news_articles ADD UNIQUE(news_feed_id)"
  end
end
