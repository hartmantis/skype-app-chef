# Encoding: UTF-8

require_relative '../spec_helper'

describe 'skype-app::default::app' do
  describe file('/Applications/Skype.app'), if: os[:family] == 'darwin' do
    it 'exists' do
      expect(subject).to be_directory
    end
  end
end
