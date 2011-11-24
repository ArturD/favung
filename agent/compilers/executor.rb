require "logger"

$logger = Logger.new(STDERR)

class Executor
  def initialize(cmd)
    @cmd = cmd
  end

  def run(in_file, out_file)
    $logger.info "exec #{@cmd} < #{in_file} > #{out_file} 2> /dev/null"
    `ulimit -t 2; #{@cmd} < #{in_file} > #{out_file} 2> /dev/null`
    $logger.info "exit status: #{$?.exitstatus}"
    return false, false, true if $?.exitstatus != 0
    return false, false, false
  end
end
