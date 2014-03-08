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

end
