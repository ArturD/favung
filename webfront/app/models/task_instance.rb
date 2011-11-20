class TaskInstance
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name
  field :description

  field :input_path
  field :output_path

  embedded_in :task
end
