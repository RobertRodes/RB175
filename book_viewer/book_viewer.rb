require 'tilt/erubis'
require "sinatra"
require "sinatra/reloader"

def massage_text(filename)
  result = '<p>' + File.read(filename) + '</p>'
  result.gsub("\n\n", "</p><p>").gsub("\n ", "<br>")
end

get "/" do
  @title = 'The Adventures of Sherlock Holmes'
  @toc = File.readlines 'data/toc.txt'
  erb :home
end

get '/chapters/1' do
  @title = 'A Scandal in Bohemia'
  @toc = File.readlines 'data/toc.txt'
  @chapter = massage_text('data/chp1.txt')
  erb :chapter
end

get '/chapters/2' do
  @title = 'The Red-Headed League'
  @toc = File.readlines 'data/toc.txt'
  @chapter = massage_text('data/chp2.txt')
  erb :chapter
end
