# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_skype_app_ubuntu'

describe Chef::Provider::SkypeApp::Ubuntu do
  let(:name) { 'default' }
  let(:run_context) { ChefSpec::SoloRunner.new.converge.run_context }
  let(:new_resource) { Chef::Resource::SkypeApp.new(name, run_context) }
  let(:provider) { described_class.new(new_resource, run_context) }

  describe '.provides?' do
    let(:platform) { nil }
    let(:node) { ChefSpec::Macros.stub_node('node.example', platform) }
    let(:res) { described_class.provides?(node, new_resource) }

    context 'Ubuntu' do
      let(:platform) { { platform: 'ubuntu', version: '14.04' } }

      it 'returns true' do
        expect(res).to eq(true)
      end
    end
  end

  describe '#install!' do
    before(:each) do
      [
        :include_recipe, :enable_i386_arch!, :add_repository!, :package
      ].each do |m|
        allow_any_instance_of(described_class).to receive(m)
      end
    end

    it 'ensures the APT cache is updated' do
      p = provider
      expect(p).to receive(:include_recipe).with('apt')
      p.send(:install!)
    end

    it 'enables the i386 architecture' do
      p = provider
      expect(p).to receive(:enable_i386_arch!)
      p.send(:install!)
    end

    it 'adds the APT repository' do
      p = provider
      expect(p).to receive(:add_repository!)
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

  describe '#add_repository!' do
    let(:node) { { 'lsb' => { 'codename' => 'testy' } } }

    before(:each) do
      allow_any_instance_of(described_class).to receive(:node).and_return(node)
    end

    it 'enables the partner APT repo' do
      p = provider
      expect(p).to receive(:apt_repository).with('partner').and_yield
      expect(p).to receive(:uri).with('http://archive.canonical.com')
      expect(p).to receive(:components).with(%w(partner))
      expect(p).to receive(:distribution).with('testy')
      expect(p).to receive(:action).with(:add)
      p.send(:add_repository!)
    end
  end

  describe '#enable_i386_arch!' do
    it 'ensures i386 packages are enabled' do
      p = provider
      expect(p).to receive(:execute).with('dpkg --add-architecture i386')
        .and_yield
      expect(p).to receive(:only_if).and_yield
      cmd = 'dpkg --print-architecture; dpkg --print-foreign-architectures'
      expect(p).to receive(:shell_out!).with(cmd)
        .and_return(double(stdout: "x86_64\ni386"))
      expect(p).to receive(:notifies).with(:run,
                                           'execute[apt-get update]',
                                           :immediately)
      p.send(:enable_i386_arch!)
    end
  end
end
