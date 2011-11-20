class SubmissionsController < ApplicationController
  def new
  end

  def show
    @submission = Submission.find(params[:id])
  end

  def create
    submission = Submission.create!
    submission.solution_path = submission.id.to_s
    submission.save!
    GridFileSystemHelper::store_file(submission.solution_path, params[:script][:script])

    AgentConnection.run_script(submission)

    redirect_to submission_path(submission)
  end
end
