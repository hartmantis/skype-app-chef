# Encoding: UTF-8

require_relative '../spec_helper'

describe 'skype-app::default' do
  let(:runner) { ChefSpec::SoloRunner.new }
  let(:chef_run) { runner.converge(described_recipe) }

  it 'installs Skype' do
    expect(chef_run).to install_skype_app('default')
  end
end
