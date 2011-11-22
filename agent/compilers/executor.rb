class Executor
  def initialize(cmd)
    @cmd = cmd
  end

  def run(in_file, out_file)
    `#{@cmd} < #{in_file} > #{out_file} 2> /dev/null`
    return false, false, true if $?.exitstatus != 0
    return false, false, false
  end
end
