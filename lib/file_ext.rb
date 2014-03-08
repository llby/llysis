require "find"
require 'json'

DEFAULT_PATH = "var/redmine-2.5.0"

module FileJson

  def make_json
    list = []

    excludes = []
    excludes << "^#{DEFAULT_PATH}/lib/plugins/"
    excludes << "^#{DEFAULT_PATH}/test/"
    excludes << "^#{DEFAULT_PATH}/doc/"
    excludes << "\.png$"

    Find.find(DEFAULT_PATH) do |f|
      
      is_add = true
      excludes.each do |e|
        if /#{e}/ =~ f
          is_add = false
          break
        end
      end

      if is_add
      unless File.directory?(f)
        # tmp = {path: File.basename(f), count: open(f).each{}.lineno}
        fs = f.split("/")
        fs.slice!(0, 2)
        tmp = {path: fs.join("/"), count: open(f).each{}.lineno}
        list << tmp
      end
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
      (data['count'] / 10).floor.times do |i|
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
