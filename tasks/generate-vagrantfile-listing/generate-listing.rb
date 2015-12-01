#!/usr/bin/env ruby

require 's3'
require 'erb'
require 'ostruct'

service = S3::Service.new(
  access_key_id: ENV['AWS_ACCESS_KEY_ID'],
  secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
)

S3_BUCKET = 'micropcf'

objs_by_day = {}
service.buckets.find(S3_BUCKET).objects.each do |obj|
	next if !obj.key.start_with?('nightly/Vagrantfile-v')

  match = /Vagrantfile-(.+)\.([A-Za-z]+)$/.match(obj.key)
	version = match[1]
  distro = match[2]

	objs_by_day[obj.last_modified.to_date] ||= {}
	objs_by_day[obj.last_modified.to_date][version] ||= []
	objs_by_day[obj.last_modified.to_date][version] << {distro: distro, path: obj.key}
end

def binding_from_hash(hash)
	OpenStruct.new(hash).instance_eval { binding }
end

erb = ERB.new(File.read('listing.html.erb'), 0, '>')

listing = service.buckets.find(S3_BUCKET).objects.build('nightly/index.html')
listing.content = erb.result(binding_from_hash({:days => objs_by_day, :s3bucket => S3_BUCKET}))
listing.content_type = "text/html"
listing.save

print "Uploaded nightly Vagrantfile listing."
