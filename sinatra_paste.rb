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
require 'tilt/erb'
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
		     {:date=>Time.now.utc - 5000, :title=>"title 5", :language=>"4", :paste=>"some paste 5000", :id=>1000}, 
		     {:date=>Time.now.utc - 4000, :title=>"title 4", :language=>"1", :paste=>"some paste 4000", :id=>1001},
		     {:date=>Time.now.utc - 3000, :title=>"title 3", :language=>"2", :paste=>"some paste 3000", :id=>1002},
		     {:date=>Time.now.utc - 2000, :title=>"title 2", :language=>"2", :paste=>"some paste 2000", :id=>1003},
		     {:date=>Time.now.utc - 1000, :title=>"title 1", :language=>"3", :paste=>"some paste 1000", :id=>1004},
		     {:date=>Time.now.utc, :title=>"Latest title", :language=>"4", :paste=>"some paste latest", :id=> 1005}
		   ]
  set :languages, {"1"=>"Text", "2"=>"Javascript", "3"=>"Python", "4"=>"Ruby"}
  set :ids, 1005

#########################################################################################################


  not_found do
    [404, {"Content-Type" => "text/plain"},["404 get to fuck"]]
  end

  get '/' do
    erb :index, :locals => {:paste_data => settings.the_pastes.reverse}
  end

  post '/paste' do
    throw :halt, [400, {"Content-Type" => "text/plain"}, ["400 Bad Request"]] unless The::App.check_params(params)
    settings.ids += 1
    paste = { :date=>Time.now.utc, 
              :title=>params["paste_title"], 
              :paste=>params["paste_input"], 
              :language=>params["paste_language"], 
              :id=>settings.ids }
    settings.the_pastes << paste
    paste.to_json
  end

  def self.check_params(params)
    settings.log.debug "params: " + params.inspect
    
    if params["paste_input"].nil? ||
       params["paste_language"].nil? ||
       params["paste_title"].nil?
      return false
    else
      return true
    end
  end

end # End of the App class
end # End of the Generator module
