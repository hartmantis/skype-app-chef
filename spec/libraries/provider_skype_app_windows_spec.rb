# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_skype_app_windows'

describe Chef::Provider::SkypeApp::Windows do
  let(:name) { 'default' }
  let(:new_resource) { Chef::Resource::SkypeApp.new(name, nil) }
  let(:provider) { described_class.new(new_resource, nil) }

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
