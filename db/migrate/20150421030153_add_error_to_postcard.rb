class AddErrorToPostcard < ActiveRecord::Migration
  def change
    add_column :postcards, :error, :integer
  end
end
