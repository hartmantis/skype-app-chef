# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_skype_app_mac_os_x'

describe Chef::Provider::SkypeApp::MacOsX do
  let(:name) { 'default' }
  let(:run_context) { ChefSpec::SoloRunner.new.converge.run_context }
  let(:new_resource) { Chef::Resource::SkypeApp.new(name, run_context) }
  let(:provider) { described_class.new(new_resource, run_context) }

  describe 'PATH' do
    it 'returns the app directory' do
      expected = '/Applications/Skype.app'
      expect(described_class::PATH).to eq(expected)
    end
  end

  describe '.provides?' do
    let(:platform) { nil }
    let(:node) { ChefSpec::Macros.stub_node('node.example', platform) }
    let(:res) { described_class.provides?(node, new_resource) }

    context 'Mac OS X' do
      let(:platform) { { platform: 'mac_os_x', version: '10.10' } }

      it 'returns true' do
        expect(res).to eq(true)
      end
    end
  end

  describe '#install!' do
    it 'uses a dmg_package to install Skype' do
      p = provider
      expect(p).to receive(:dmg_package).with('Skype').and_yield
      expect(p).to receive(:source).with(described_class::URL)
      expect(p).to receive(:action).with(:install)
      p.send(:install!)
    end
  end

  describe '#remove!' do
    it 'removes all the Skype directories' do
      p = provider
      [
        described_class::PATH,
        File.expand_path('~/Library/Application Support/Skype')
      ].each do |d|
        expect(p).to receive(:directory).with(d).and_yield
        expect(p).to receive(:recursive).with(true)
        expect(p).to receive(:action).with(:delete)
      end
      p.send(:remove!)
    end
  end
end
