require "uuidtools"
require "optparse"
require "logger"
require "yaml"
$options = {
  :compiler => :cpp,
  :package_root => nil,
  :source_path => nil,
}

options_parser = OptionParser.new do |opts|
  opts.on("-c", "--compiler EXTENSION", "default compiler") do |ext|
    $options[:compiler] = :cpp if ext == "cpp"
  end
  opts.on("-p", "--package_root ROOT", "package_root") do |ext|
    $options[:package_root]  = ext
  end
  opts.on("-s", "--source_path FILE", "source path") do |ext|
    $options[:source_path]  = ext
  end
end
options_parser.parse!
if $options[:source_path] == nil 
  puts "specify source path (-s)"
  exit
end
if $options[:package_root] == nil 
  puts "specify package root (-p)"
  exit
end

class Files
  def self.new_temp
    return "/tmp/#{UUIDTools::UUID.random_create.to_s}"
  end
end

log_file = Files.new_temp
logger = Logger.new(log_file)

require "./compilers/cpp_compiler.rb"
require "./comparers/int_comparer.rb"

class Compiler
  def self.for(type)
    return CppCompiler.new
  end
end
class Paths
  def self.PackageRoot
    return $options[:package_root]
  end
end
class Source 
  def self.type
    return $options[:compiler_type]
  end
  def self.path
    return $options[:source_path]
  end
end

require "#{$options[:package_root]}/judge.rb"
status = judge
#puts Marshal.dump({:status => status, :log_file => log_file})
puts ({:status => status, :log_file => log_file}).to_yaml
