# Encoding: UTF-8
#
# Cookbook Name:: skype-app
# Library:: provider_skype_app_ubuntu
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
require 'chef/dsl/include_recipe'
require_relative 'provider_skype_app'

class Chef
  class Provider
    class SkypeApp < Provider::LWRPBase
      # An provider for Skype for Ubuntu.
      #
      # @author Jonathan Hartman <j@p4nt5.com>
      class Ubuntu < SkypeApp
        include Chef::DSL::IncludeRecipe

        provides :skype_app, platform: 'ubuntu'

        private

        #
        # Enable the i386 arch and APT partner repo, then install Skype.
        #
        # (see SkypeApp#install!)
        #
        def install!
          include_recipe 'apt'
          enable_i386_arch!
          add_repository!
          package('skype') { action :install }
        end

        #
        # Remove the Skype package. At removal time, the APT partner repo and
        # i386 arch may potentially be depdended on by other packages as well,
        # so must be left behind.
        #
        # (see SkypeApp#remove!)
        #
        def remove!
          package('skype') { action :remove }
        end

        #
        # Use an apt_repository resource to enable the Ubuntu partner
        # repository for the Skype packages.
        #
        def add_repository!
          apt_repository 'partner' do
            uri 'http://archive.canonical.com'
            components %w(partner)
            distribution node['lsb']['codename']
            action :add
          end
        end

        #
        # Use an execute resource to ensure the i386 arch required for Skype
        # for Ubuntu is enabled.
        #
        def enable_i386_arch!
          execute 'dpkg --add-architecture i386' do
            only_if do
              cmd = 'dpkg --print-architecture; ' \
                    'dpkg --print-foreign-architectures'
              !shell_out!(cmd).stdout.lines.include?('i386')
            end
            notifies :run, 'execute[apt-get update]', :immediately
          end
        end
      end
    end
  end
end
