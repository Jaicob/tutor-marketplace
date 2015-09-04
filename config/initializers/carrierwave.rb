require "fog/rackspace/storage"
require "carrierwave"

if Rails.env.test? or Rails.env.cucumber?
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end
else
  CarrierWave.configure do |config|
    # config.storage = :fog
    # config.enable_processing = false
                      
  	config.fog_credentials = {
    	provider:              'AWS',                      
    	aws_access_key_id:     ENV['AWS_ACCESS_KEY'],                     
    	aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],                  
    	region:                ENV['AWS_REGION'],                 
    	# host:                  ENV['AWS_HOST'],       
    	# endpoint:              ENV['AWS_ENDPOINT'] 
  	}
  	config.fog_directory  = 'rails-axon-uploads' 
    # config.fog_host       = ENV['AWS_HOST'],                    
  	config.fog_public     = true                                        
  	config.fog_attributes = { 'Cache-Control' => "max-age=#{2.day.to_i}" } 
  end
end

