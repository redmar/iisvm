class CreateStoredImages < ActiveRecord::Migration
  def self.up
    create_table :stored_images do |t|
      t.string  :filename
      t.string  :tags
      t.string  :image_file_name     #  arborgreens/image01.jpg
      t.string  :image_content_type  # 'image/jpeg'
      t.integer :image_file_size     #  File.size('filename')

      t.timestamps
    end
  end

  def self.down
    drop_table :stored_images
  end
end
