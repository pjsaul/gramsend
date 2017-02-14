class AddFormviewsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :formviews, :integer
  end
end
