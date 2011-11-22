#!/usr/bin/env ruby
require 'yaml'
require 'mongo'
require 'mongoid'
require 'eventmachine'
require 'logger'
require 'amqp'
require 'fileutils'
require './git_judge.rb'
$logger = Logger.new(STDOUT)

$logger.info "loading models"
['submission', 'run', 'task'].each do |file| 
  f = "../webfront/app/models/#{file}.rb"
  require f
  $logger.info f
end

$logger.info "loading helpers"
['../webfront/lib/favung/grid_file_system_helper'].each do |file| 
  f = "#{file}.rb"
  require f
  $logger.info f
end

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


TMP_DIR = '/tmp/favung'

class Agent
  def execute(submission)
    source_path = submission.solution_path
    run = submission.runs.create :status => :running 
    output_path = run.output_path

    judge = GitJudge.new(submission.task)
    result = judge.judge submission
    
    run.status = result[:status]
    run.time = 1.23
    run.save!
    

    puts "== Output =="
    puts run.output
  end

  def prepare_environment
    FileUtils.rm_rf(TMP_DIR)
    FileUtils.mkdir_p(TMP_DIR)
  end
end

agent = Agent.new

AMQP.start(configuration[:amqp]) do |connection|
  channel = AMQP::Channel.new(connection)
  queue = channel.queue("submissions", auto_delete: true)
  exchange = channel.direct("")
  queue.subscribe do |message|
    message = BSON.deserialize(message)
    $logger.info "Processing script #{message['submission_id']}"
    submission = Submission.find(message["submission_id"])
    if not submission
      $logger.error "Submission not found. id:  #{message['submission_id']}"
    else
      agent.execute submission
    end
  end
end
