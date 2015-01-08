class CatsController < ApplicationController
  before_action :ensure_owner, only: [:edit, :update]

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
    @cat.owner_id = current_user.id
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

    def ensure_owner
      @cat = Cat.find(params[:id])
      unless @cat.owner_id == current_user.id
        flash[:error] = ["Only owner is allowed to do that!"]
        redirect_to cat_url(@cat)
      end
    end
end
