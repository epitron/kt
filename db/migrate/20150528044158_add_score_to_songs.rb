class AddScoreToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :score, :integer, null: false, default: 0
    add_index  :songs, :score, order: { score: :desc }
  end
end
