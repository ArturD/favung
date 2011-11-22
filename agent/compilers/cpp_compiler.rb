require 'uuidtools'
require './compilers/executor.rb'

class CppCompiler
  def initialize
    @tmp_root = "/tmp" # TODO from conf
  end

  def compile(tmp_cpp)
    tmp_name = UUIDTools::UUID.random_create.to_s # TODO semantic prefix
    #tmp_cpp = "#{@tmp_root}/#{tmp_name}.cpp"
    tmp_exe = "#{@tmp_root}/#{tmp_name}"
    #save_source(s)
    `g++ #{tmp_cpp} -o #{tmp_exe}`
    if $?.exitstatus != 0
      return nil, false
    end
    return Executor.new("#{tmp_exe}"), true
  end
  
  def save_source(source, tmp_cpp)
    File.open(tmp_cpp, 'w') do |f|
      f.write(source)
    end
  end
end


