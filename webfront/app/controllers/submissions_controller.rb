class SubmissionsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @submissions = current_user.submissions.order_by([:created_at, :desc])
  end

  def new
    @submission = Submission.new()
    @submission.source = 
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
    submission = current_user.submissions.build(params[:submission] )
    submission.runner_name = "CppRunner" #FIXME user should be able to set this
    submission.save!
    AgentConnection.run_script(submission)

    redirect_to submissions_path, notice: 'Your solution has been submitted successfuly'
  end
  
  def show
    @submission = current_user.submissions.find(params[:id])
  end
end
