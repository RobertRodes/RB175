# hello_world.rb

#require 'erb'
require_relative 'advice'     # loads advice.rb

class HelloWorld
  def erb(view, local = {} )
    message = local[:message]    
    template = File.read("views/#{view}.erb")
    ERB.new(template).result(binding)
  end

  def call(env)
    case env['REQUEST_PATH']
    when '/'
      ['200', {"Content-Type" => 'text/html'}, [erb(:index)]]
    when '/advice'
      piece_of_advice = Advice.new.generate    # random piece of advice
      ['200', {"Content-Type" => 'text/html'}, [erb(:advice, message: piece_of_advice)]]
    else
      [
        '404',
        {"Content-Type" => 'text/html', "Content-Length" => '48'},
        [erb(:not_found)]
      ]
    end
  end
end
