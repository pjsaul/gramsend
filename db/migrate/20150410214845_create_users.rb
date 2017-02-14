class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :insta_id
      t.string :insta_name
      t.datetime :last_activity
      t.integer :admin

      t.timestamps null: false
    end
  end
end
