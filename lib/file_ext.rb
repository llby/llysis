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
      f.write list.to_json
    end
    
  end

  def make_data
    list = []

    dataset = File.read("var/data.json")
    dataset = JSON.parse(dataset)
    dataset.each_with_index do |data, j|
      data['count'].times do |i|
        list << [i+1,j+1];
      end
    end

    File.open("var/data2.json", 'w') do |f|
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
  module_function :make_data
  module_function :make_grep

end
