require 'tilt/erubis'
require 'sinatra'
require 'sinatra/reloader'
require 'yaml'

helpers do
  def count_interests
    @users.map { |_, v| v[:interests].size }.sum
  end
end

# not_found do
#   redirect '/'
# end

before do
  @users = YAML.load_file('data/users.yaml')
end

get '/' do
  redirect '/users'
end

get '/users' do
  erb :users
end

get '/:name' do
  @name = params[:name].to_sym
  @email = @users[@name][:email]
  @interests = @users[@name][:interests]
  erb :user, layout: :layout
end

get '/users-all' do
  erb :users_all, :layout => :layout_users_all
end
