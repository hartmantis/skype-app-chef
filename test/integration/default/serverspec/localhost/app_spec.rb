# Encoding: UTF-8

require_relative '../spec_helper'

describe 'skype-app::default::app' do
  describe file('/Applications/Skype.app'), if: os[:family] == 'darwin' do
    it 'exists' do
      expect(subject).to be_directory
    end
  end

  describe file('/Program Files (x86)/Skype'), if: os[:family] == 'windows' do
    it 'exists' do
      expect(subject).to be_directory
    end
  end

  describe package('skype'), if: !%w(darwin windows).include?(os[:family]) do
    it 'is installed' do
      expect(subject).to be_installed
    end
  end
end
