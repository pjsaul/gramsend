class AddZipToUser < ActiveRecord::Migration
  def change
    add_column :users, :addr_zip, :string
  end
end
