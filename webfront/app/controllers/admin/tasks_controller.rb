class Admin::TasksController < Admin::ApplicationController
  def index
    @tasks = Task.all
  end

  def show
    @task = Task.find(params[:id])
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])
    if @task.update_attributes(params[:task])
      flash[:notice] = "Task updated"
      redirect_to admin_task_url @task
    else 
      flash[:notice] = "Task update error"
      redirect_to edit_admin_task_url @task
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    redirect_to admin_tasks_url
  end
end
