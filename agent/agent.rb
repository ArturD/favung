#!/usr/bin/env ruby
require 'yaml'
require 'mongo'
require 'mongoid'
require 'eventmachine'
require 'logger'
require 'amqp'
require 'fileutils'

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
$logger.info "loading helpers"
['../webfront/lib/favung/grid_file_system_helper'].each do |file| 
  f = "#{file}.rb"
  require f
  $logger.info f
end

TMP_DIR = '/tmp/favung'

class CppRunner
  def run(source)
    save_source(source)
    compile
    execute_binary
  end

  def compile
    `g++ source.cpp -o submission`
  end

  def execute_binary
    `./submission`
  end

  def save_source(source)
    File.open('source.cpp', 'w') do |f|
      f.write(source)
    end
  end
end

class RubyRunner
  def run(source)
    `ruby -e "#{source}"`
  end
end

class Agent
  def execute(submission)
    source_path = submission.solution_path
    run = submission.runs.build
    run.status = :running
    submission.save!
    output_path = run.output_path
    
    # TODO(zurkowski) Replace it with something nicer :)
    runner = case submission.runner_name
             when "CppRunner"
               CppRunner.new
             when "RubyRunner"
               RubyRunner.new
             else
               $logger.info "Unknown runner name: #{submission.runner_name}"
             end

    prepare_environment

    output = nil
    Dir.chdir(TMP_DIR) do
      source = submission.source
      run.output = runner.run(source)
    end

    run.status = :acc  # FIXME hardcode
    run.time = 1.23   
    
    submission.save!

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
