class RankImage < ActiveRecord::Base
  has_attached_file :image  
  attr_accessor :ranking  
  
  def ranked_tags
    if tags.blank? then
      rank!
      
      count = 0
      tags_array = []
      @ranking.each do |pair|
        tags_array[count] = pair[0]
        count = count + 1
        break if count > 4 
      end
      tags = tags_array.join(',')
      save
    end
    tags
  end

  def tags_string
    return ranked_tags.gsub(',', ' ')
  end
  
  def has_tag(atag)
    ranked_tags.split(',').include?(atag)
  end
  
  def tags_array
    ranked_tags.split(',')
  end

  def rank!
    # hier moet een cmdline ranking programma gedraait worden
    
    logger.debug("cd #{RAILS_ROOT}/lire; java -jar FeatureExtractor.jar #{image.path}")
    #string_output = `cd #{RAILS_ROOT}/lire; java Score`
    string_output = `cd #{RAILS_ROOT}/lire; java -jar FeatureExtractor.jar #{image.path}`
#     string_output = <<-EOS
# cannonbeach/Image15.jpg 0.73930544
# barcelona/Image05.jpg 0.72177225
# cannonbeach/Image16.jpg 0.68707997
# cannonbeach/Image25.jpg 0.68567413
# cannonbeach/Image29.jpg 0.6726887
# cannonbeach/Image04.jpg 0.669376
# cannonbeach/Image20.jpg 0.6667272
# cannonbeach/Image17.jpg 0.65516055
# arborgreens/Image04.jpg 0.64925903
# barcelona/Image10.jpg 0.6480853
# barcelona/Image27.jpg 0.6319743
# barcelona/Image11.jpg 0.62995267
# cannonbeach/Image28.jpg 0.6292231
# cannonbeach/Image01.jpg 0.6287079
# cannonbeach/Image09.jpg 0.62496257
# cannonbeach/Image27.jpg 0.6237453
# cannonbeach/Image18.jpg 0.61673063
# cannonbeach/Image13.jpg 0.61091185
# cannonbeach/Image11.jpg 0.60945934
# barcelona/Image29.jpg 0.60803634    
#     EOS
    
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
    tagsArray.each do |tag|
      puts 'adding ' + score.to_s + ' for tag \'' + tag + '\''
      @ranking[tag] = (@ranking[tag] || 0) + score.to_f 
    end
    puts @ranking.class
  end
  
  def ranking
    @ranking == nil ? {} : @ranking.sort {|a,b| b[1] <=> a[1]} 
  end
end
