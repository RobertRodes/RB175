require 'pry'

@toc = File.readlines('data/toc.txt')

def in_paragraphs(text)
  result = text.split("\n\n").map.with_index do |p, i|
    p.gsub!("\n ", '<br>')
    "<p id=#{i}>" << p << '</p>'
  end.join
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
      binding.pry

    results << { 
      chapter: chapter, 
      title: title, 
      paragraphs: matching_paragraphs 
    } if matching_paragraphs.any?
  end

  results
end

matching_chapters('Adler').each do |el|
  puts el[:title]
  puts el[:paragraphs]    
end



