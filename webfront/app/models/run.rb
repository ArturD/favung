require 'uuidtools'

class Run
  include Mongoid::Document
  include Mongoid::Timestamps

  field :output_path
  field :error_code, :type => Integer
  field :status, :type => Symbol
  field :time,   :type => Float

  attr_protected :output_path

  embedded_in :submission

  def output
    logger.info "trying to read #{self.output_path}"
    if GridFileSystemHelper.file_exists?("#{self.output_path}")
      @output ||= GridFileSystemHelper::read_file("#{self.output_path}")
    end
  end
  def output=(val)
      self.output_path = "run_output/" + UUIDTools::UUID.random_create.to_s
      GridFileSystemHelper::store_file(self.output_path, val)
      @output = val 
  end
  
  before_create :generate_output_path

  protected
  def generate_output_path
    logger.info "generating output_path (old:#{@output_path}) "
    @output_path = "run_output/" + UUIDTools::UUID.random_create.to_s
    logger.info "generating output_path (new:#{@output_path}) "
  end
end
