class AddScoreToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :score, :integer, :null => false, :default => 0
  end
end
