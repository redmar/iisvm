class StoredImagesController < ApplicationController

  def index
    @images = StoredImage.find(:all)
  end
  
  def show
    @image = StoredImage.find(params[:id])
  end
  
  def rank
    
  end
end
