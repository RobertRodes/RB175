require 'tilt/erubis'
require "sinatra"
require "sinatra/reloader"

get "/" do
  @filenames = Dir.glob("public/*").reject do |f| 
    File.directory?(f)
  end.map do |f| 
    File.basename(f)
  end.sort

  @filenames.reverse! if params[:sort] == "desc"

  erb :filelist
end

require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

get "/" do
  @files = Dir.glob("public/*")
  erb :filelist
end
