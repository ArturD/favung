class RankingController < ApplicationController
  def index
    @users = User.all.sort {|a,b| b.score <=> a.score }
    @tasks = Task.all
  end
end
