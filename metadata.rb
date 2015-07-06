# Encoding: UTF-8
#
# rubocop:disable SingleSpaceBeforeFirstArg
name             'skype-app'
maintainer       'Jonathan Hartman'
maintainer_email 'j@p4nt5.com'
license          'apache2'
description      'Installs Skype'
long_description 'Installs Skype'
version          '0.1.1'

depends          'dmg', '~> 2.2'
depends          'windows', '~> 1.37'
depends          'apt', '~> 2.7'

supports         'mac_os_x'
supports         'windows'
# rubocop:enable SingleSpaceBeforeFirstArg
