# xamarin_build plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-xamarin_build)

## Getting Started

This project is a [fastlane](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-xamarin_build`, add it to your project by running:

```bash
fastlane add_plugin xamarin_build
```

## About xamarin_build

Small plugin to build and configure xamarin android\ios projects

## Actions
### extract_certificate 
extract signing certificate from provision profile

### xamarin_build
build xamarin project specific platform(iPhone, iPhoneSimulator) and target(Release, Debug)

### xamarin_update_configuration
update property of specific configuration in xamarin c# project config file


## Example

Check out the [example `Fastfile`](fastlane/Fastfile) to see how to use this plugin. 


## Run tests for this plugin

To run both the tests, and code style validation, run

````
rake
```

To automatically fix many of the styling issues, use 
```
rubocop -a
```

## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this repository.

## Troubleshooting

If you have trouble using plugins, check out the [Plugins Troubleshooting](https://github.com/fastlane/fastlane/blob/master/fastlane/docs/PluginsTroubleshooting.md) doc in the main `fastlane` repo.

## Using `fastlane` Plugins

For more information about how the `fastlane` plugin system works, check out the [Plugins documentation](https://github.com/fastlane/fastlane/blob/master/fastlane/docs/Plugins.md).

## About `fastlane`

`fastlane` is the easiest way to automate building and releasing your iOS and Android apps. To learn more, check out [fastlane.tools](https://fastlane.tools).
