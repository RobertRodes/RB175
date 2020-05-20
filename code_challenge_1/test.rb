  @filenames = Dir.children('./public').select do |f| 
    !File.directory?('./public/' + f) && f[0] != '.'
  end
  @titles = @filenames.map { |f| f[0...(f.index('.'))] }
p @filenames
puts 
p @titles