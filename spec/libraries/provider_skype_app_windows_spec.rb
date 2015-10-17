# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_skype_app_windows'

describe Chef::Provider::SkypeApp::Windows do
  let(:name) { 'default' }
  let(:run_context) { ChefSpec::SoloRunner.new.converge.run_context }
  let(:new_resource) { Chef::Resource::SkypeApp.new(name, run_context) }
  let(:provider) { described_class.new(new_resource, run_context) }

  describe 'PATH' do
    it 'returns the app directory' do
      expected = File.expand_path('/Program Files (x86)/Skype')
      expect(described_class::PATH).to eq(expected)
    end
  end

  describe 'URL' do
    it 'uses the Windows download URL' do
      expected = 'http://www.skype.com/go/getskype-windows'
      expect(described_class::URL).to eq(expected)
    end
  end

  describe '.provides?' do
    let(:platform) { nil }
    let(:node) { ChefSpec::Macros.stub_node('node.example', platform) }
    let(:res) { described_class.provides?(node, new_resource) }

    context 'Windows' do
      let(:platform) { { platform: 'windows', version: '2012R2' } }

      it 'returns true' do
        expect(res).to eq(true)
      end
    end
  end

  describe '#install!' do
    before(:each) do
      allow_any_instance_of(described_class).to receive(:remote_path)
        .and_return('/tmp/skype.exe')
    end

    it 'uses a windows_package to install Skype' do
      p = provider
      expect(p).to receive(:windows_package).with('Skype').and_yield
      expect(p).to receive(:source).with('/tmp/skype.exe')
      expect(p).to receive(:installer_type).with(:inno)
      expect(p).to receive(:action).with(:install)
      expect(p).to receive(:only_if).and_yield
      expect(File).to receive(:exist?).with(described_class::PATH)
      p.send(:install!)
    end
  end

  describe '#remove!' do
    before(:each) do
      allow_any_instance_of(described_class)
        .to receive(:installed_skype_packages).and_return(%w(pkg1 pkg2))
    end

    it 'removes all the installed Skype packages' do
      p = provider
      %w(pkg1 pkg2).each do |pkg|
        expect(p).to receive(:windows_package).with(pkg).and_yield
        expect(p).to receive(:action).with(:remove)
      end
      p.send(:remove!)
    end
  end

  describe '#installed_skype_packages' do
    before(:each) do
      allow_any_instance_of(described_class).to receive(:installed_packages)
        .and_return('Skype™ 1.2' => 'thing', 'Dropbox' => 'stuff')
    end

    it 'returns only the Skype package(s)' do
      expected = ['Skype™ 1.2']
      expect(provider.send(:installed_skype_packages)).to eq(expected)
    end
  end

  describe '#remote_path' do
    before(:each) do
      allow(Net::HTTP).to receive(:get_response).with(URI(described_class::URL))
        .and_return('location' => 'http://example.com/skype.exe')
    end

    it 'returns the redirect destination' do
      expect(provider.send(:remote_path)).to eq('http://example.com/skype.exe')
    end
  end
end
