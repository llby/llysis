require "file_ext"

class AnalysisController < ApplicationController
  
  
  def index
  end
  
  def filelist
    @j = File.read("var/data.json")
    @list = JSON.parse(@j)

    respond_to do |format|
      format.html
      format.json { render json: @j }
    end
  end

  def data
    @j = File.read("var/data2.json")
    
    respond_to do |format|
      format.html
      format.json { render json: @j }
    end
  end

  def make
    FileJson.make_json
    FileJson.make_data
  end

  def grep
    con = "ruby"
    result = ""
    begin
      result = `grep -HIinr #{con} #{DEFAULT_PATH}`
    rescue
      puts "error"
    end

    resdata = []
    result.split("\n").each do |res|
      ress = res.split(":")
      resdata << [ress[0],ress[1]]
    end

    @j = File.read("var/data.json")
    filelist = JSON.parse(@j)
    index = 0
    datalist = []
    filelist.each_with_index do |list, k|

      is_hit = false
      index.upto(resdata.length-1) do |i|

        if "#{DEFAULT_PATH}/#{list['path']}" == resdata[i][0]
          datalist << [k,resdata[i][1]]
        else
          index = i
          break
        end

      end

    end




#    @j = resdata.to_json
    @j = datalist.to_json


    respond_to do |format|
      format.html
      format.json { render json: @j }
    end
  end
end
