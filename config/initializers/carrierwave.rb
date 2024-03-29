require "fog/rackspace/storage"
require "carrierwave"

# if Rails.env.test? or Rails.env.cucumber? or Rails.env.development?
#   CarrierWave.configure do |config|
#     config.storage = :file
#     config.enable_processing = false
#   end
# else
  CarrierWave.configure do |config|
    config.storage = :fog
    config.fog_credentials = {
      provider:              'AWS',
      aws_access_key_id:     ENV['AWS_ACCESS_KEY'],
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
      region:                ENV['AWS_REGION'],
    }
    config.fog_directory  = ENV['S3_BUCKET']
    config.fog_public     = true
    config.fog_attributes = { 'Cache-Control' => "max-age=#{2.day.to_i}" }
  # end  
end
