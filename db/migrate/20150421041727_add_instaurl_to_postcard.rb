class AddInstaurlToPostcard < ActiveRecord::Migration
  def change
    add_column :postcards, :insta_url, :string
  end
end
