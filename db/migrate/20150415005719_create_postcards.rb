class CreatePostcards < ActiveRecord::Migration
  def change
    create_table :postcards do |t|
t.integer :user_id
t.string :lob_id
t.string :to_name
t.string :to_address_one
t.string :to_address_two
t.string :to_city
t.string :to_state
t.string :to_zip
t.string :to_country
t.string :from_name
t.string :from_address_one
t.string :from_address_two
t.string :from_city
t.string :from_state
t.string :from_zip
t.string :from_country
t.string :thumbnail_front_url
t.string :thumbnail_back_url
t.datetime :sent_date
t.datetime :expected_delivery_date
t.string :insta_postusername
t.text :insta_caption
t.string :insta_location
t.datetime :insta_date
t.integer :insta_likes_count
t.integer :insta_comments_count
t.text :insta_comments
t.string :insta_fromusername
t.text :postcard_message

      t.timestamps null: false
    end
  end
end
