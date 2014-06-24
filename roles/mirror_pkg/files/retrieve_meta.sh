#!/bin/bash

cd /var/lib/gems-mirror

curl -L -O http://rubygems.org/latest_specs.4.8.gz
curl -L -O http://rubygems.org/Marshal.4.8.Z
curl -L -O http://rubygems.org/specs.4.8.gz
curl -L -O http://rubygems.org/yaml
(
test ! -d quick && mkdir quick
cd quick
curl -L -O http://rubygems.org/quick/latest_index.rz
)

ruby retrieve_gemspec.rb
