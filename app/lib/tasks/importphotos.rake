require(File.join(File.dirname(__FILE__), '..', '..', 'config', 'boot'))
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'tasks/rails'



namespace :import do
  desc "Import photos from public/images/annotation.txt file as StoredImages."
  task :photos => :environment do
    
    filename = File.expand_path('public/images/annotation.txt')
    
    throw "Error, #{filename} does not exist!" if not File.exists? filename

    puts "Opening #{filename} for reading..."
    f = File.new(filename, 'r') 
    puts f
    f.each_line do |line|
      tokens = line.split(' ')
      image_filename = tokens.shift + '.jpg'
      tags = tokens
      puts 'processing ' + image_filename
      
      newimg = StoredImage.new :filename => image_filename, :tags => tags.join(',')
      newimg.image = File.new(File.expand_path("public/images/#{image_filename}"), 'r')
      newimg.save
    end
    f.close
  end
end