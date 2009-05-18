class AddColumnScoreToStoredImages < ActiveRecord::Migration
  def self.up
    add_column :stored_images, :score, :float
  end

  def self.down
    remove_column :stored_images, :score
  end
end
