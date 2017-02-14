class ChangePostcards < ActiveRecord::Migration
  def change
    change_table :postcards do |t|
      t.change :insta_id, :string
    end

  end
end
