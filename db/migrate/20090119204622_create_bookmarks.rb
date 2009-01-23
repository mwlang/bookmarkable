class CreateBookmarks < ActiveRecord::Migration
  def self.up
    create_table :bookmarks do |t|
      t.string :url
      t.string :title
      t.string :description, :limit => 1024
      t.string :note, :limit => 1024
      t.string :author
      t.string :keywords, :limit => 1024
      t.timestamps
    end
  end

  def self.down
    drop_table :bookmarks
  end
end
