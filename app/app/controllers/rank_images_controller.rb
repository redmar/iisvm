class RankImagesController < ApplicationController

  def index
    @rank_images = RankImage.find(:all)
  end
  
  def show
    @rank_image = RankImage.find(params[:id])
  end
  
  # show image upload form
  def new
    @rank_image = RankImage.new
  end
  
  # image uploaded, create the new image ranking it 
  def create
    @rank_image = RankImage.new(params[:rank_image])
    if @rank_image.save then
      redirect_to rank_image_path(@rank_image)
    else
      redirect_to new_rank_image_path()
    end
  end
  
end
