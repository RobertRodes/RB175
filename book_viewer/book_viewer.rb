require 'tilt/erubis'
require 'sinatra'
require 'sinatra/reloader'

helpers do
  def in_paragraphs(text)
    result = text.split("\n\n").map.with_index do |pg, i|
      pg.gsub!("\n ", '<br>')
      "<p id=#{i}>" << pg << '</p>'
    end.join
  end

  def highlight(text, words)
    text.gsub(words, "<strong>#{words}</strong>")
  end
end

def each_chapter
  @toc.each_with_index do |title, idx|
    num = idx + 1
    chapter_text = File.read("data/chp#{num}.txt")
    yield num, title, chapter_text
  end
end

def matching_chapters(query)
  results = []

  return results if !query || query.empty?

  each_chapter do |chapter, title, chapter_text|
    matching_paragraphs = {}

    chapter_text.split("\n\n").each_with_index do |pg, idx|
      matching_paragraphs[idx] = pg if pg.include?(query) 
    end

    results << { 
      chapter: chapter, 
      title: title, 
      paragraphs: matching_paragraphs 
    } if matching_paragraphs.any?
  end

  results
end

not_found do
  redirect '/'
end

before do
  @toc = File.readlines('data/toc.txt')
end

get '/' do
  @title = 'The Adventures of Sherlock Holmes'
  erb :home
end

get '/chapters/:num' do
  num = params[:num].to_i
  redirect '/' unless (1..@toc.size).cover? num
  @title = "Chapter #{num}: #{@toc[num - 1]}"
  @chapter = in_paragraphs(File.read("data/chp#{num}.txt"))
  erb :chapter
end

get '/search' do
  @results = matching_chapters(params[:query])
  erb :search
end
