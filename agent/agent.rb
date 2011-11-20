#!/usr/bin/env ruby
require 'yaml'
require 'mongo'
require 'mongoid'
require 'eventmachine'
require 'logger'
require 'amqp'

$logger = Logger.new(STDOUT)

def load_configuration
  environment = ENV['ENV'] || 'development'
  mongo_configuration = YAML::load_file('config/mongo.yml')
  logger_configuration = YAML::load_file('config/logger.yml')
  amqp_configuration = YAML::load_file('config/amqp.yml')

  return {
    mongo: mongo_configuration[environment],
    logger: logger_configuration[environment],
    amqp: amqp_configuration[environment]
  }
end

configuration = load_configuration
Mongoid.configure do |config|
  $logger.info "Connecting to mongo: host#{configuration[:mongo]["host"]} db:#{configuration[:mongo]["database"]}"
  connection = Mongo::Connection.new(configuration[:mongo]["host"])
  $db = connection.db(configuration[:mongo]["database"])
  config.master = $db
end

$logger.info "loading models"
['submission', 'run'].each do |file| 
  f = "../webfront/app/models/#{file}.rb"
  require f
  $logger.info f
end

class Agent
  def execute(submission)
    input_path = submission.solution_path
    run = submission.runs.build
    run.status = :running
    submission.save!

    output_path = run.output_path

    script_file = Mongo::GridFileSystem.new($db).open(input_path, 'r')
    script = script_file.read
    script_file.close

    output = `ruby -e "#{script}"`
    run.status = :acc
    run.time = 1.23

    output_file = Mongo::GridFileSystem.new($db).open(output_path, 'w')
    output_file.write output
    output_file.close
    submission.save!
  end
end

agent = Agent.new

AMQP.start(configuration[:amqp]) do |connection|
  channel = AMQP::Channel.new(connection)
  queue = channel.queue("submissions", auto_delete: true)
  exchange = channel.direct("")
  queue.subscribe do |message|
    message = BSON.deserialize(message)
    $logger.info "Processing script #{message['input']}"
    submission = Submission.find(message["submission_id"])
    if not submission
      $logger.error "Submission not found. id:  #{message['submission_id']}"
    else
      agent.execute submission
    end
  end
end
