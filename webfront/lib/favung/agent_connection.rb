require 'bunny'
require 'yaml'

module AgentConnection
  extend self

  def configure(config)
    @bunny = Bunny.new(config)
    @bunny.start
    # FIXME we create queue to make sure durable queue exists
    # this should be probably confitured in rabbitMQ. 
    # check if this is nessesary anyways.
    @queue = Bunny::Queue.new(@bunny, 'submissions', :durable =>true) 
    @exchange = @bunny.exchange("", :type => :queue)
  end


  def run_script(submission)
    message = {submission_id: submission.id }
    publish message
  end

  private
  def publish(message)
    @exchange.publish BSON.serialize(message), key: 'submissions', persistent: true
  end
end

config = YAML.load_file("#{Rails.root}/config/amqp.yml") || {}
config = config[Rails.env] || {}
AgentConnection.configure(config)
