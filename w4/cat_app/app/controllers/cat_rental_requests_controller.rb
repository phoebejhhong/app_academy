class CatRentalRequestsController < ApplicationController
  before_action :ensure_owner, only: [:approve, :deny]

  def new
    @cat_rental_request = CatRentalRequest.new
    @all_cats = Cat.all
    render :new
  end

  def create
    @cat_rental_request = CatRentalRequest.new(cat_rental_request_params)
    @cat_rental_request.requester_id = current_user.id
    if @cat_rental_request.save
      redirect_to @cat_rental_request.cat
    else
      @all_cats = Cat.all
      render :new
    end
  end

  def approve
    @cat_rental_request = CatRentalRequest.find(params[:cat_rental_request_id])
    @cat_rental_request.approve!
    redirect_to @cat_rental_request.cat
  end

  def deny
    @cat_rental_request = CatRentalRequest.find(params[:cat_rental_request_id])
    @cat_rental_request.deny!
    redirect_to @cat_rental_request.cat
  end


  private
    def cat_rental_request_params
      params.require(:cat_rental_request).permit(:cat_id, :start_date, :end_date)
    end

    def ensure_owner
      cat_rental_request = CatRentalRequest.find(params[:cat_rental_request_id])
      cat = Cat.find(cat_rental_request.cat_id)
      redirect_to cat_url(cat) unless cat.owner_id == current_user.id
    end

end
