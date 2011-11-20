require 'bunny'
require 'yaml'

module AgentConnection
  extend self

  def configure(config)
    @bunny = Bunny.new(config)
    @bunny.start
    @exchange = @bunny.exchange("")
  end


  def run_script(submission)
    message = {submission_id: submission.id }
    publish message
  end

  private
  def publish(message)
    @exchange.publish BSON.serialize(message), key: 'submissions'
  end
end

config = YAML.load_file("#{Rails.root}/config/amqp.yml") || {}
config = config[Rails.env] || {}
AgentConnection.configure(config)
