# Encoding: UTF-8

include_recipe 'skype-app'

skype_app 'default' do
  action :remove
end
