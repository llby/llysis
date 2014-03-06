require "find"
require 'json'

DEFAULT_PATH = "var/ruby-2.1.1"

module FileJson

  def make_json
    list = []

    i = 0
    Find.find(DEFAULT_PATH) do |f|
      unless File.directory?(f)
        tmp = {path: File.basename(f), count: open(f).each{}.lineno}
        #p tmp
        i += 1
        list << tmp
      end
    end

    File.open("var/data.json", 'w') do |f|
      #f.write "var lists = #{list.to_json}"
      f.write list.to_json
    end
    
  end

  def make_grep
    result = []
    open("result.txt") do |f|
      while line = f.gets
        result << line.split(':')
      end
    end

  end
  
  module_function :make_json
  module_function :make_grep

end
