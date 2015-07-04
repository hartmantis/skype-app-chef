# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_skype_app_ubuntu'

describe Chef::Provider::SkypeApp::Ubuntu do
  let(:name) { 'default' }
  let(:new_resource) { Chef::Resource::SkypeApp.new(name, nil) }
  let(:provider) { described_class.new(new_resource, nil) }

  describe '#install!' do
    let(:node) { { 'lsb' => { 'codename' => 'testy' } } }

    before(:each) do
      allow_any_instance_of(described_class).to receive(:node).and_return(node)
      [:include_recipe, :apt_repository, :package].each do |m|
        allow_any_instance_of(described_class).to receive(m)
      end
    end

    it 'enables the partner APT repo' do
      p = provider
      expect(p).to receive(:include_recipe).with('apt')
      expect(p).to receive(:apt_repository).with('partner').and_yield
      expect(p).to receive(:uri).with('http://archive.canonical.com')
      expect(p).to receive(:components).with(%w(partner))
      expect(p).to receive(:distribution).with('testy')
      expect(p).to receive(:action).with(:add)
      p.send(:install!)
    end

    it 'uses a package to install Skype' do
      p = provider
      expect(p).to receive(:package).with('skype').and_yield
      expect(p).to receive(:action).with(:install)
      p.send(:install!)
    end
  end

  describe '#remove!' do
    it 'uses a package to remove Skype' do
      p = provider
      expect(p).to receive(:package).with('skype').and_yield
      expect(p).to receive(:action).with(:remove)
      p.send(:remove!)
    end
  end
end
