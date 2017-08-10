class AddColumnCityNewsArticles < ActiveRecord::Migration[5.0]
  def change
  	add_column :news_articles, :city, :string, :default => "Saharanpur"
  end
end
