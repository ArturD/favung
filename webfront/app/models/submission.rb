class Submission
  include Mongoid::Document
  include Mongoid::Timestamps

  field :solution_path
  field :status_oeverride, :type => Symbol

  def status
    if defined? status_override
      return status_override
    end
    if runs.size == 0
      return :pending
    end
    if runs.any? {|run| run.status == :acc }
      return :acc
    end
    if runs.any? {|run| run.status == :running }
      return :running
    end
    last_run = runs.max_by {|a,b| a.created_at <=> b.created_at}
    return last_run.status
  end
  embeds_many :runs
end
