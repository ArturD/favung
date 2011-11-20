class TasksController < ApplicationController
  def index
    @tasks = Task.all
  end

  def show
    @task = Task.find(params[:id])
    @task_content = GridFileSystemHelper::read_file(@task.content_path)
  end
  
  def new
    @task = Task.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @task }
    end
  end
  
  def create
    task = Task.new(params[:task])
    GridFileSystemHelper::store_file(task.content_path, params[:task][:content])
    task.save!
    redirect_to task    
  end
end
