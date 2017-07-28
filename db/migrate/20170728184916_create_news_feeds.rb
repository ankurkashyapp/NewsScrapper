class CreateNewsFeeds < ActiveRecord::Migration[5.0]
  def change
    create_table :news_feeds do |t|

      t.timestamps
    end
  end
end
