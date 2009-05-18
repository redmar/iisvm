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
  
  def rank!
    # hier moet een cmdline ranking programma gedraait worden
    
    puts "cd #{RAILS_ROOT}/lire; java -jar FeatureExtractor.jar #{image.path}"
    #string_output = `cd #{RAILS_ROOT}/lire; java Score`
    string_output = `cd #{RAILS_ROOT}/lire; java -jar FeatureExtractor.jar #{image.path}`
    
    result_array = string_output.split("\n")
    result_array.each do |result_string_pair|
      image_name, image_score = result_string_pair.split(' ')
      image = StoredImage.find_by_filename image_name
      puts "adding img:#{image_name} with tags: (#{image.tags_string}) and score: #{image_score}"
      add_tags_with_score(image.tags_array, image_score)
    end
    
  end
  
  def add_tags_with_score(tagsArray, score)
    @ranking ||= {}
    @results ||= 0.0
    tagsArray.each do |tag|
      if (@ranking[tag] == nil)
        if (has_tag(tag))
          @results += 1.0
        end
      end
      puts 'adding ' + score.to_s + ' for tag \'' + tag + '\''
      @ranking[tag] = (@ranking[tag] || 0) + score.to_f 
    end
    self.score = @results / tags_array.size * 100.0
    puts self.score
    self.save()
    puts @ranking.class
  end
  
  def ranking
    @ranking == nil ? {} : @ranking.sort {|a,b| b[1] <=> a[1]} 
  end
end
