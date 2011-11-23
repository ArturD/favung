require 'open3'
require 'uuidtools'
require 'yaml'
class GitJudge
  def initialize(task)
    @local_root = "./cache"
    @local_path = "#{@local_root}/#{task.short_name}_#{task.id}/"
    @task = task
  end

  def judge(submission)
    if not (update or clone)
      return { :status => :error, :error => "problem with git repository"}
    end
    
    result = "unknonw";
    source_path = save_source submission.source
    $logger.info "exec: ruby runner.rb -c cpp -s #{source_path} -p \"#{@local_path}\""
    result = `ruby runner.rb -c cpp -s #{source_path} -p \"#{@local_path}\"`
    $logger.info " >> "
    $logger.info result
    if $?.exitstatus != 0
      result = { :status => :error, :error => "Runner returned error code: #{status.value.exitstatus}, stderr:\n#{stderr.read}" }
    else
      result = YAML::load(result)
    end
    return result
  end
  def clone
    remote_path = @task.git_path
    `git clone #{remote_path} #{@local_path}`
    if $?.exitstatus != 0
      return false
    end
    return true
  end
  def update
    remote_path = @task.git_path
    if not File.directory? @local_path
      return false
    end
    Dir.chdir(@local_path) do
      `git pull #{remote_path}`
      if $?.exitstatus != 0
        return false
      end
    end
    return true
  end
  def save_source(source)
    file = "/tmp/#{UUIDTools::UUID.random_create}.cpp"
    File.open(file, 'w') do |f|
      f.write(source)
    end
    return file
  end
end


