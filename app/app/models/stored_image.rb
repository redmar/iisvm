class StoredImage < ActiveRecord::Base
  has_attached_file :image
  
  def tags_string
    return tags.gsub(',', ' ')
  end
  
  def has_tag(atag)
    tags.split(',').include?(atag)
  end
  
  def tags_array
    tags.split(',')
  end
end
