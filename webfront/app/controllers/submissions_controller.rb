class SubmissionsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @submissions = current_user.submissions
  end

  def new
  end

  def show
    @submission = Submission.find(params[:id])
  end

  def create
    submission = current_user.submissions.build(task: params[:submission][:task])
    submission.runner_name = "CppRunner" #FIXME user should be able to set this
    submission.source = params[:submission][:source]
    submission.save!

    AgentConnection.run_script(submission)

    redirect_to submission_path submission, notice: 'Your solution has been submitted successfuly'
  end

  # FIXME how method name should look like here ?
  def show_mine
    @submission = current_user.submissions.find(params[:id])
  end
end
