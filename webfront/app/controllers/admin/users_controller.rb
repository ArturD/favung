class Admin::UsersController < Admin::ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      @user.role = params[:user][:role] #FIXME validation needed ?
      @user.save!
      flash[:notice] = "User updated"
      redirect_to admin_user_url @user
    else 
      flash[:notice] = "User update error"
      redirect_to edit_admin_user_url @user
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    redirect_to admin_users_url
  end
end
