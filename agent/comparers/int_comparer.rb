require "scanf"
require "logger"
class IntComparer
  def compare new, orign
    logger = Logger.new(STDERR)
    File.open(new, 'r') do |fnew|
    File.open(orign, 'r') do |forign|
      i = 0
      while true
        i+=1
        ni = fnew.scanf("%d")
        fi = forign.scanf("%d")
        return true if ni == [] and fi == []
        if ni == [] 
          logger.info "unexpected end of inputfile after #{i-1} ints"
          logger.info "expected #{fi} and maybe more"
          return false
        end
        if fi == [] 
          logger.info "excesive input after all #{i-1} ints"
          logger.info "unexpected int #{ni}"
          return false
        end
        if fi != ni 
          logger.info "wrong int after #{i-1} ints"
          logger.info "was #{ni} expected #{fi}"
          return false
        end
      end
    end
    end
    return true
  end
end

