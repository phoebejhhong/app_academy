class ContactsController < ApplicationController

  def index
    render json: User.find(params[:user_id]).contacts + User.find(params[:user_id]).shared_contacts
  end

  def show
    contact = Contact.find(params[:id])
    render json: contact
  end

  def create
    contact = Contact.new(contact_params)
    if contact.save
      render json: contact
    else
      render(
       json: contact.errors.full_messages, status: :unprocessable_entity
      )
    end
  end

  def update
    contact = Contact.find(params[:id])
    if contact.update(contact_params)
      render json: contact
    else
      render(
        json: contact.errors.full_messages, status: :unprocessable_entity
      )
    end
  end

  def destroy
    contact = Contact.find(params[:id])
    render json: contact
    contact.destroy
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :email, :user_id)
  end

end
