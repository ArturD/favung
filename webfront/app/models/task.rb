class Task
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name
  field :short_name
  field :description_path
  field :git_path
  
  attr_protected :description_path
  
  has_many :submissions

  def description=(val)
      self.description_path = "task/" + UUIDTools::UUID.random_create.to_s
      GridFileSystemHelper::store_file(self.description_path, val)
      @description = val
  end
  def description
    @description ||= GridFileSystemHelper::read_file(self.description_path)
  end
  def description_html
    BlueCloth.new(description).to_html
  end
end

