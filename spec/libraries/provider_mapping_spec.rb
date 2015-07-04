# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_mapping'

describe 'gimp::provider_mapping' do
  let(:platform) { nil }
  let(:app_provider) do
    Chef::Platform.platforms[platform] && \
      Chef::Platform.platforms[platform][:default][:skype_app]
  end

  context 'Mac OS X' do
    let(:platform) { :mac_os_x }

    it 'uses the OS X app provider' do
      expect(app_provider).to eq(Chef::Provider::SkypeApp::MacOsX)
    end
  end

  context 'Windows' do
    let(:platform) { :windows }

    it 'uses the Windows app provider' do
      expect(app_provider).to eq(Chef::Provider::SkypeApp::Windows)
    end
  end

  context 'Ubuntu' do
    let(:platform) { :ubuntu }

    it 'Uses the Ubuntu app provider' do
      expect(app_provider).to eq(Chef::Provider::SkypeApp::Ubuntu)
    end
  end

  context 'CentOS' do
    let(:platform) { :centos }

    it 'has no app provider' do
      expect(app_provider).to eq(nil)
    end
  end
end
