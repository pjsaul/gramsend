class AddInstaIdToPostcard < ActiveRecord::Migration
  def change
    add_column :postcards, :insta_id, :integer
  end
end
