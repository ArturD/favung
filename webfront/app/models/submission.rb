class Submission
  include Mongoid::Document
  include Mongoid::Timestamps

  field :solution_path
  
  def script=(val)
    @script = val
  end

  def script
    @script
  end

  embeds_many :runs
end
