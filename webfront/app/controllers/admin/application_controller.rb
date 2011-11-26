class Admin::ApplicationController < ApplicationController
  before_filter :is_admin?
  layout "admin"

  private
  def is_admin?
    unless current_user && current_user.admin?
      flash[:error] = "You must have admin privileges to access admin panel"
      redirect_to new_session_path :user
    end
  end
end
