$stdout.sync = true
####################################################################################################
# @author       David Kirwan https://github.com/davidkirwan/sinatra_paste
# @description  Simple pastebin/gist clone
#
# @date         2015-12-28
####################################################################################################
##### Require statements
require 'sinatra/base'
require 'logger'
require 'json'
require 'puma'
require 'tilt/erb'
require 'sqlite3'
require File.join(File.dirname(__FILE__), '/sinatra_paste/api')
require File.join(File.dirname(__FILE__), '/sinatra_paste/db')



module The
class App < Sinatra::Base

  ##### Variables
  enable :static, :sessions, :logging
  set :environment, :production
  set :root, File.join(File.dirname(__FILE__) + '/..')
  set :public_folder, File.join(root, '/public')
  set :views, File.join(root, '/views')
  set :server, :puma

  # Create the logger instance
  set :log, Logger.new(STDOUT)
  set :level, Logger::DEBUG
  #set :level, Logger::INFO
  #set :level, Logger::WARN

  The::API.configure()

#########################################################################################################


  not_found do
    [404, {"Content-Type" => "text/plain"},["404 get to fuck"]]
  end

  get '/' do
    erb :index, :locals => {:paste_data => The::API.get_pastes()}
  end

  get '/pastes' do
    the_pastes = The::API.get_pastes()
    return the_pastes.to_json
  end

  get '/pastes/:id' do |id|
    erb :edit_paste, :locals => {:paste_data => The::API.get_paste(id)}
  end

  post '/pastes' do
    settings.log.debug "params: " + params.inspect
    
    check, message = The::API.check_post_paste_params(params)
    unless check then throw :halt, [400, {"Content-Type" => "text/plain"}, [message.to_json]]; end
    paste = The::API.add_paste(params)
    {:messages=>[message, paste]}.to_json
  end

  put '/pastes/:id' do |id|
    check, message = The::API.check_post_paste_params(params)
    unless check then throw :halt, [400, {"Content-Type" => "text/plain"}, [message.to_json]]; end
    paste = The::API.update_paste(id, params)
    {:messages=>[message, paste]}.to_json
  end

  delete '/pastes/:id' do |id|
    return The::API.delete_paste(id).to_json
  end

end # End of the App class
end # End of the Generator module
