class SubmissionsController < ApplicationController
  def new
    @submission = Submission.new()
    @submission.script = 
    "#include<iostream>
using namespace std;
int main() {
  // use to reduce iostream overhead. It's still slower than stdio
  ios_base::sync_with_stdio(false);
  
  int n;
  cin >> n;

  while(n--) {
    int x;
    cin >> x;
    cout << x <<endl;
  }
  return 0;
}
    "
  end

  def create
    submission = Submission.create!
    run = submission.runs.build
    submission.save!
    GridFileSystemHelper::store_file(submission.id.to_s, params[:submission][:script])

    AgentConnection.run_script(submission.id.to_s, run.id.to_s)

    redirect_to submission_run_path(submission, run)
  end
end
