# Encoding: UTF-8

require_relative '../spec_helper'

describe 'skype-app::uninstall::app' do
  describe file('/Applications/Skype.app'), if: os[:family] == 'darwin' do
    it 'does not exist' do
      expect(subject).not_to be_directory
    end
  end

  describe file('/Program Files (x86)/Skype'), if: os[:family] == 'windows' do
    it 'does not exist' do
      expect(subject).not_to be_directory
    end
  end

  describe package('skype'), if: !%w(darwin windows).include?(os[:family]) do
    it 'is not installed' do
      expect(subject).not_to be_installed
    end
  end
end
