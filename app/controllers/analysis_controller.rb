require "file_ext"

class AnalysisController < ApplicationController
  
  
  def index
  end
  
  def filelist
    @j = File.read("var/data.json")
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
#    FileJson.make_json
#    FileJson.make_data
#    FileJson.make_coverage
  end

  def grep

    datalist = []
    con = params[:con]
    unless con == ""
      result = ""
      begin
        result = `grep -HIinr #{con} #{DEFAULT_PATH}`
        result.encode!("UTF-16BE", :invalid => :replace, :undef => :replace, :replace => '?')
        result.encode!(Encoding::UTF_8)
      rescue
        puts "error"
      end

      resdata = []
      result.split("\n").each do |res|
        ress = res.split(":")
        resdata << [ress[0],ress[1]]
      end
#p resdata.count
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
    end

#p datalist.count

    @j = datalist.to_json
    respond_to do |format|
      format.html
      format.json { render json: @j }
    end
  end

  def coverage
    @j = File.read("var/data4.json")
    respond_to do |format|
      format.html
      format.json { render json: @j }
    end
  end
end
