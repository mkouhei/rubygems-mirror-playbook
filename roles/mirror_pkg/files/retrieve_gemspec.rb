#!/usr/bin/env ruby
# this script from http://wp.bug.org/archives/262
# -*- coding: utf-8 -*-
require 'net/http'
 
VERBOSE=false
 
GEMSRC="http://production.s3.rubygems.org:80"
BASEDIR="/var/lib/gems-mirror"
GEMDIR="#{BASEDIR}/gems"
MARSHALDIR="#{BASEDIR}/quick/Marshal.4.8"
 
def fetch(url)
  response = Net::HTTP.get_response(URI.parse(url))
  case response
  when Net::HTTPSuccess
    response
  when Net::HTTPRedirection
    fetch(response['Location'])
  else
    return nil
  end
end
 
puts "mirror src #{GEMSRC}" if VERBOSE
Dir.foreach(GEMDIR) do |gemfile|
  next if File.ftype("#{GEMDIR}/#{gemfile}") != 'file'
 
  gemname = File.basename gemfile, '.gem'
  gemspecfile = gemname + '.gemspec.rz'
  marshalfile = "#{MARSHALDIR}/#{gemspecfile}"
 
  if File.exist?(marshalfile) and
     File.mtime("#{GEMDIR}/#{gemfile}") < File.mtime(marshalfile)
    puts "skip #{gemspecfile}" if VERBOSE
    next
  end
 
  url = "#{GEMSRC}/quick/Marshal.4.8/#{gemspecfile}"
  puts "fetch #{gemspecfile}"
  res = fetch(url)
  if res.nil?
    puts "  ERROR: #{url}"
    next
  end
 
  File.open(marshalfile, 'wb') do |io|
    io.write(res.body)
  end
 
end
__END__
