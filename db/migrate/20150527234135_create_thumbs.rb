class CreateThumbs < ActiveRecord::Migration
  def change
    create_table :thumbs do |t|
      t.integer :song_id, index: true
      t.string :session_id, index: true
      t.boolean :up

      t.timestamps null: false
    end
  end
end
