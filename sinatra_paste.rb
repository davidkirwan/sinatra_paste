$stdout.sync = true
####################################################################################################
# @author       David Kirwan https://github.com/davidkirwan/sinatra_morse
# @description  Sinatra Morse Code Generator
#
# @date         2015-03-03
####################################################################################################
##### Require statements
require 'sinatra/base'
require 'logger'
require 'json'
require 'puma'
require File.join(File.dirname(__FILE__), '/lib/paste')

module The
class App < Sinatra::Base


  ##### Variables
  enable :static, :sessions, :logging
  set :environment, :production
  set :root, File.dirname(__FILE__)
  set :public_folder, File.join(root, '/public')
  set :views, File.join(root, '/views')
  set :server, :puma

  # Create the logger instance
  set :log, Logger.new(STDOUT)
  set :level, Logger::DEBUG
  #set :level, Logger::INFO
  #set :level, Logger::WARN

  # Options hash
  set :options, {:log => settings.log, :level => settings.level}
  
  # Pastes array
  set :the_pastes, [ 
		     {:date=>Time.now.utc - 5000, :paste=>"some paste 5000"}, 
		     {:date=>Time.now.utc - 4000, :paste=>"some paste 4000"},
		     {:date=>Time.now.utc - 3000, :paste=>"some paste 3000"},
		     {:date=>Time.now.utc - 2000, :paste=>"some paste 2000"},
		     {:date=>Time.now.utc - 1000, :paste=>"some paste 1000"},
		     {:date=>Time.now.utc, :paste=>"some paste latest"}
		   ]

#########################################################################################################


  not_found do
    [404, {"Content-Type" => "text/plain"},["404 get to fuck"]]
  end

  get '/' do
    erb :index, :locals => {:paste_data => settings.the_pastes.reverse}
  end

  post '/paste' do
    throw :halt, [400, {"Content-Type" => "text/plain"},["400 Bad Request"]] unless not params["paste_input"].nil? 
    settings.log.debug "params: " + params.inspect
    paste = {:date=>Time.now.utc, :paste=>params["paste_input"]}
    settings.the_pastes << paste
    paste.to_json
  end

end # End of the App class
end # End of the Generator module
