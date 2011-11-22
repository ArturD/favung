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
    if GridFileSystemHelper.file_exists?("#{self.output_path}")
      @output ||= GridFileSystemHelper::read_file("#{self.output_path}")
    end
  end
  def output=(val)
      self.output_path = "runoutput/" + UUIDTools::UUID.random_create.to_s
      GridFileSystemHelper::store_file(self.output_path, val)
      @output = val 
  end
end
