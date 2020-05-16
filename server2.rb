require 'socket'

def parse_request(request_line)
  method, path_and_query, protocol = request_line.split
  path, query = path_and_query.split('?')

  params = (query || '').split('&').each_with_object({}) do |elt, hsh|
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

  params = parse_request(request_line).last
  number = params['number']

  client.puts '<html>'
  client.puts '<body>'
  client.puts '<h3>Counter</h3>'
  client.puts "<p>The current number is #{number}.</p>"
  client.puts "<p><a href='?number=#{number + 1}'>Up</a>&nbsp;&nbsp;&nbsp;"
  client.puts "<a href='?number=#{number - 1}'>Down</a></p>"
  client.puts '</html>'
  client.puts '</body>'
  client.close
end