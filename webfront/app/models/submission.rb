class Submission
  include Mongoid::Document
  include Mongoid::Timestamps

  field :solution_path
  field :status_oeverride, :type => Symbol
  field :runner_name
  
  attr_protected :solution_path

  belongs_to :task
  belongs_to :user
  embeds_many :runs

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

  def source=(val)
      self.solution_path = "solution/" + UUIDTools::UUID.random_create.to_s
      GridFileSystemHelper::store_file(self.solution_path, val)
      @source = val
  end
  def source
    logger.info "trying to read #{self.solution_path}"
    @source ||= GridFileSystemHelper::read_file(self.solution_path)
  end
end
