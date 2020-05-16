require 'socket'

def parse_request(request_line)
  method, path_and_query, protocol = request_line.split
  path, query = path_and_query.split('?')

  params = query.split('&').each_with_object({}) do |elt, hsh|
    k, v = elt.split('=')
    hsh[k] = v.to_i
  end

  [method, path, params]
end
server = TCPServer.new('localhost', 3003)
loop do
  client = server.accept
  request_line = client.gets
  next if !request_line || request_line =~ /favicon/

  client.puts "HTTP/1.1 200 OK"
  client.puts "Content-Type: text/html\r\n\r\n"

  dice = parse_request(request_line).last
  client.puts '<html>'
  client.puts '<body>'
  client.puts "<h5>Rolling #{dice['dice']} #{dice['sides']}-sided dice...</h5>"
  dice['rolls'].times do
    client.puts '<p>'
    dice['dice'].times { client.print "#{rand(dice['sides']) + 1}   " }
    client.puts "</p>"
  end
  client.puts '</html>'
  client.puts '</body>'
  client.close
end