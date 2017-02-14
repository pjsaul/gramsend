class AddPageviewsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :pageviews, :integer
  end
end
