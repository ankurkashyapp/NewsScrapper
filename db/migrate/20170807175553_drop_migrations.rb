class DropMigrations < ActiveRecord::Migration[5.0]
  def change
  	execute "DROP TABLE news_feeds"
  end
end
