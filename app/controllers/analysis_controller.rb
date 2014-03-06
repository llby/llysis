require "file_ext"

class AnalysisController < ApplicationController
  
  
  def index
  end
  
  def data
    @j = File.read("var/data.json")

    respond_to do |format|
      format.html
      format.json { render json: @j }
    end
  end

  def make
    FileJson.make_json
  end

end
