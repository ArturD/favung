class Run
  include Mongoid::Document
  include Mongoid::Timestamps

  field :output_path
  field :error_code, :type => Integer
  field :status, :type => Symbol
  field :time,   :type => Float

  embedded_in :submission
end
