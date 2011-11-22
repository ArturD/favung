class TasksController < ApplicationController
  def index
    @tasks = Task.all
  end

  def show
    @task = Task.find(params[:id])
  end
  
  def new
    @task = Task.new

    respond_to do |format| 
      format.html 
      format.json { render json: @task }
    end
  end
  
  def create
    task = Task.new(params[:task])
    task.save!
    redirect_to task    
  end
end
