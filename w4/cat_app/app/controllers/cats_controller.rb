class CatsController < ApplicationController
  def index
    col = params[:ordered_by] || 'name'
    order = params[:order] || ''
    if order.empty?
      order = "asc"
    elsif order == "asc"
      order = "desc"
    else
      order = "asc"
    end
    @cats = Cat.all.order( col => order)
    render  :index
  end

  def show
    @cat = Cat.find(params[:id])
    render :show
  end

  def new
    @cat = Cat.new
    render :new
  end

  def create
    @cat = Cat.new(cat_params)

    if @cat.save
      redirect_to @cat
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @cat = Cat.find(params[:id])
    render :edit
  end

  def update
    @cat = Cat.find(params[:id])
    if @cat.update(cat_params)
      redirect_to @cat
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
    def cat_params
      params.require(:cat).permit(:name, :description, :sex, :birth_date, :color, :image_url)
    end
end
