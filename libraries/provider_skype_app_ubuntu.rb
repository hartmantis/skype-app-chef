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
        # Enable the APT partner repo and install Skype from it.
        #
        # (see SkypeApp#install!)
        #
        def install!
          include_recipe 'apt'
          apt_repository 'partner' do
            uri 'http://archive.canonical.com'
            components %w(partner)
            distribution node['lsb']['codename']
            action :add
          end
          package 'skype' do
            action :install
          end
        end

        #
        # (see SkypeApp#remove!)
        #
        def remove!
          package 'skype' do
            action :remove
          end
        end
      end
    end
  end
end
