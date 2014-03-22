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
      list << data['count']
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
  
  def make_coverage
    datalist = []
    resdata = []

    excludes = []
    excludes << "test/"
    excludes << "\.rbenv"
    excludes << "vendor/bundle"


    dataset = File.read("var/data3.json")
    dataset = JSON.parse(dataset)
    dataset.each do |key, val|

      is_add = true
      excludes.each do |e|
        if /#{e}/ =~ key
          is_add = false
          break
        end
      end

      if is_add
        fs = key.split("/")
#        fs.slice!(0, 3)

        val.each_with_index do |v, k|
          if v && v > 0
            resdata << [fs.join("/"),k+1]
          end
        end

      end

    end

p resdata
    resdata.sort!

    @j = File.read("var/data.json")
    filelist = JSON.parse(@j)
    filelist.sort!{|a,b|
      a['path'] <=> b['path']
    }

    index = 0
    filelist.each_with_index do |list, k|

      index.upto(resdata.length-1) do |i|

        if "#{DEFAULT_PATH}/#{list['path']}" == resdata[i][0]
          datalist << [k,resdata[i][1]]
        else
          index = i
          break
        end

      end

    end

    File.open("var/data4.json", 'w') do |f|
      f.write datalist.to_json
    end



  end



  module_function :make_json
  module_function :make_data
  module_function :make_grep
  module_function :make_coverage

end
