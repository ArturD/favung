class Task
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name
  field :short_name
  field :content_path

  attr_accessor :content # FIXME: transient field so that form helper works. There must be a better way
  
  embeds_many :task_instances
  
  before_create :generate_content_path

  protected
  def generate_content_path
    puts "generating content_path (old:#{@content_path}, short_name:#{@short_name}) "
    @content_path = "task_content_" + UUIDTools::UUID.random_create.to_s
  end
end

