Skype App Cookbook
==================
[![Cookbook Version](https://img.shields.io/cookbook/v/skype-app.svg)][cookbook]
[![OS X Build Status](https://img.shields.io/travis/RoboticCheese/skype-app-chef.svg)][travis]
[![Windows Build Status](https://img.shields.io/appveyor/ci/RoboticCheese/skype-app-chef.svg)][appveyor]
[![Linux Build Status](https://img.shields.io/circleci/project/RoboticCheese/skype-app-chef.svg)][circle]
[![Code Climate](https://img.shields.io/codeclimate/github/RoboticCheese/skype-app-chef.svg)][codeclimate]
[![Coverage Status](https://img.shields.io/coveralls/RoboticCheese/skype-app-chef.svg)][coveralls]

[cookbook]: https://supermarket.chef.io/cookbooks/skype-app
[travis]: https://travis-ci.org/RoboticCheese/skype-app-chef
[appveyor]: https://ci.appveyor.com/project/RoboticCheese/skype-app-chef
[circle]: https://circleci.com/gh/RoboticCheese/skype-app-chef
[codeclimate]: https://codeclimate.com/github/RoboticCheese/skype-app-chef
[coveralls]: https://coveralls.io/r/RoboticCheese/skype-app-chef

A Chef cookbook for Skype.

Requirements
============

This cookbook currently supports OS X, Windows, and Ubuntu. It uses the dmg,
windows, and apt community cookbooks to enable that platform support.

The provider for Windows requires Chef >= 12.4.0

Usage
=====

Either add the default recipe to your run_list or implement the resource
directly in a recipe of your own.

Recipes
=======

***default***

Installs Skype.

Resources
=========

***skype_app***

Used to install the Skype app.

Syntax:

    skype_app 'default' do
        action :install
    end

Actions:

| Action     | Description     |
|------------|-----------------|
| `:install` | Install Skype   |
| `:remove`  | Uninstall Skype |

Attributes:

| Attribute  | Default    | Description          |
|------------|------------|----------------------|
| action     | `:install` | Action(s) to perform |

Providers
=========

***Chef::Provider::SkypeApp::MacOsX***

Provider for Mac OS X platforms.

***Chef::Provider::SkypeApp::Windows***

Provider for Windows platforms.

***Chef::Provider::SkypeApp::Ubuntu***

Provider for Ubuntu platforms.

***Chef::Provider::SkypeApp***

A parent provider for all the platform-specific providers to subclass.

Contributing
============

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Add tests for the new feature; ensure they pass (`rake`)
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create a new Pull Request

License & Authors
=================
- Author: Jonathan Hartman <j@p4nt5.com>

Copyright 2015 Jonathan Hartman

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
