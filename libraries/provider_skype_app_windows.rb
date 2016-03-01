# Encoding: UTF-8
#
# Cookbook Name:: skype-app
# Library:: provider_skype_app_windows
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

require 'net/http'
require 'chef/provider/lwrp_base'
require_relative 'provider_skype_app'

class Chef
  class Provider
    class SkypeApp < Provider::LWRPBase
      # An provider for Skype for Windows.
      #
      # @author Jonathan Hartman <j@p4nt5.com>
      class Windows < SkypeApp
        PATH ||= ::File.expand_path('/Program Files (x86)/Skype').freeze
        URL ||= 'http://www.skype.com/go/getskype-windows'.freeze

        include ::Windows::Helper

        provides :skype_app, platform: 'windows'

        private

        #
        # Use a windows_package resource to download and install the package.
        # This method requires Chef >= 12.4.0, the release that first added
        # the creation of an inline remote_file resource to the windows_package
        # resource.
        #
        # (see SkypeApp#install!)
        #
        def install!
          s = remote_path
          windows_package 'Skype' do
            source s
            installer_type :inno
            action :install
            only_if { !::File.exist?(PATH) }
          end
        end

        #
        # (see SkypeApp#remove!
        #
        def remove!
          installed_skype_packages.each do |p|
            windows_package p do
              action :remove
            end
          end
        end

        #
        # Iterate over all installed packages and return an array of any Skype
        # package names.
        #
        # @return [Array] a list of installed Skype packages
        #
        def installed_skype_packages
          installed_packages.keys.select { |k| k.match(/^Skype. [0-9]/) }
        end

        #
        # Follow URL's redirect and return a final download URL. We need to
        # follow the redirect so the file gets downloaded with the .exe
        # extension and is runnable for the windows_package resource.
        #
        # @return [String] the package URL
        #
        def remote_path
          @remote_path ||= Net::HTTP.get_response(URI(URL))['location']
        end
      end
    end
  end
end
