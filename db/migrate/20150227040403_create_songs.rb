class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.string :name, index: true
      t.string :basename, index: true
      t.string :dir

      t.timestamps null: false
    end
  end
end
