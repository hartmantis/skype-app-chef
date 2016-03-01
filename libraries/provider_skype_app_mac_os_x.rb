# Encoding: UTF-8
#
# Cookbook Name:: skype-app
# Library:: provider_skype_app_mac_os_x
#
# Copyright 2015 Jonathan Hartman
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'chef/provider/lwrp_base'
require_relative 'provider_skype_app'

class Chef
  class Provider
    class SkypeApp < Provider::LWRPBase
      # An provider for Skype for Mac OS X.
      #
      # @author Jonathan Hartman <j@p4nt5.com>
      class MacOsX < SkypeApp
        PATH ||= '/Applications/Skype.app'.freeze
        URL ||= 'http://www.skype.com/go/getskype-macosx'.freeze

        provides :skype_app, platform: 'mac_os_x'

        private

        #
        # Use a dmg_package resource to download and install the package. The
        # dmg_resource creates an inline remote_file, so this is all that's
        # needed.
        #
        # (see SkypeApp#install!)
        #
        def install!
          dmg_package 'Skype' do
            source URL
            action :install
          end
        end

        #
        # For lack of a package manager, delete all of Skype's directories.
        #
        # (see SkypeApp#remove!)
        #
        def remove!
          [
            PATH,
            ::File.expand_path('~/Library/Application Support/Skype')
          ].each do |d|
            directory d do
              recursive true
              action :delete
            end
          end
        end
      end
    end
  end
end
