class Task
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name
  field :short_name
  field :content_path
  field :git_path
  
  attr_protected :content_path
  
  has_many :submissions

  def content=(val)
      self.content_path = "task/" + UUIDTools::UUID.random_create.to_s
      GridFileSystemHelper::store_file(self.content_path, val)
      @content = val
  end
  def content
    @content ||= GridFileSystemHelper::read_file(self.content_path)
  end
end

