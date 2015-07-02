# Encoding: UTF-8

require_relative '../spec_helper'

describe 'skype-app::uninstall::app' do
  describe file('/Applications/Skype.app'), if: os[:family] == 'darwin' do
    it 'does not exist' do
      expect(subject).not_to be_directory
    end
  end
end
