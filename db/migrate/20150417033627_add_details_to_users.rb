class AddDetailsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :addr_name, :string
    add_column :users, :addr_address_one, :string
    add_column :users, :addr_address_two, :string
    add_column :users, :addr_city, :string
    add_column :users, :addr_state, :string
    add_column :users, :addr_country, :string
  end
end
