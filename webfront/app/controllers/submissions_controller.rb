class SubmissionsController < ApplicationController
  def new
  end

  def show
    @submission = Submission.find(params[:id])
  end

  def create
    submission = Submission.create!
    submission.save!
    GridFileSystemHelper::store_file(submission.id.to_s, params[:script][:script])

    AgentConnection.run_script(submission)

    redirect_to submission_path(submission)
  end
end
